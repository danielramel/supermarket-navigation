import csv
import os
import numpy as np
import matplotlib.pyplot as plt  # pyright: ignore[reportMissingModuleSource]
from matplotlib.patches import Patch

# Make figures more colorful and readable
plt.style.use('seaborn-v0_8-darkgrid')
palette = plt.get_cmap('tab10').colors


def _overlay_jitter(ax, groups, positions, colors, jitter=0.08):
    """Overlay per-participant jitter points on a boxplot.
    groups: list of iterables of numeric values (e.g., [arrow, map])
    positions: list of x positions for each group (e.g., [1, 2])
    colors: list of colors for each group
    """
    for i, vals in enumerate(groups):
        if not vals:
            continue
        x0 = positions[i]
        xs = x0 + np.random.uniform(-jitter, jitter, size=len(vals))
        ax.scatter(
            xs,
            vals,
            s=36,
            color=colors[i],
            edgecolors='white',
            linewidths=0.5,
            alpha=0.9,
            zorder=3,
        )

with open('combined.csv', newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    combined = {row[reader.fieldnames[0]]: row for row in reader}


arrow_difficulty = [float(combined[i].get('arrow_difficulty')) for i in combined]
map_difficulty   = [float(combined[i].get('map_difficulty'))   for i in combined]
arrow_understand = [float(combined[i].get('arrow_understanding')) for i in combined]
map_understand   = [float(combined[i].get('map_understanding'))   for i in combined]

# Prepare one figure with multiple comparisons
os.makedirs('reports', exist_ok=True)
# 1) Boxplot: Difficulty (Arrow vs Map) — use a fresh figure
fig1, ax1 = plt.subplots()
bplot1 = ax1.boxplot(
    [arrow_difficulty, map_difficulty],
    tick_labels=['Arrow', 'Map'],
    patch_artist=True,
)
# Color the boxes
colors1 = [palette[0], palette[1]]
for patch, color in zip(bplot1['boxes'], colors1):
    patch.set_facecolor(color)
    patch.set_alpha(0.6)
for median in bplot1['medians']:
    median.set_color('#333333')
_overlay_jitter(ax1, [arrow_difficulty, map_difficulty], [1, 2], colors1)
ax1.set_ylabel('Score')
ax1.set_title('How hard was it to execute a single navigation instruction?')
# Legend for box colors
ax1.legend(
    [Patch(facecolor=colors1[0], alpha=0.6), Patch(facecolor=colors1[1], alpha=0.6)],
    ['Arrow', 'Map'],
    loc='upper left'
)
fig1.savefig(os.path.join('reports', 'difficulty_boxplot.png'))
plt.close(fig1)


# 2) Boxplot: Understanding (Arrow vs Map) — use a fresh figure
fig2, ax2 = plt.subplots()
bplot2 = ax2.boxplot(
    [arrow_understand, map_understand],
    tick_labels=['Arrow', 'Map'],
    patch_artist=True,
)
colors2 = [palette[2], palette[3]]
for patch, color in zip(bplot2['boxes'], colors2):
    patch.set_facecolor(color)
    patch.set_alpha(0.6)
for median in bplot2['medians']:
    median.set_color('#333333')
_overlay_jitter(ax2, [arrow_understand, map_understand], [1, 2], colors2)
ax2.set_ylabel('Score')
ax2.set_title('How well did you understand the navigation instructions?')
ax2.legend(
    [Patch(facecolor=colors2[0], alpha=0.6), Patch(facecolor=colors2[1], alpha=0.6)],
    ['Arrow', 'Map'],
    loc='upper left'
)
fig2.savefig(os.path.join('reports', 'understanding_boxplot.png'))
plt.close(fig2)

labels = [
    "mental_demand",
    "physical_demand",
    "temporal_demand",
    "performance",
    "effort",
    "frustration"
]
arrow_scores = {}
map_scores = {}

count = len(combined)
for label in labels:
    arrow_total = sum(int(combined[i]['arrow_'+label]) for i in combined)
    map_total   = sum(int(combined[i]['map_'+label])   for i in combined)
    arrow_scores[label] = arrow_total / count
    map_scores[label] = map_total / count

x = np.arange(len(labels))
width = 0.35

fig, ax = plt.subplots(figsize=(10, 5))
ax.bar(x - width/2, list(arrow_scores.values()), width, label='Arrow TLX', color=palette[4], alpha=0.7)
ax.bar(x + width/2, list(map_scores.values()), width, label='Map TLX', color=palette[5], alpha=0.7)
# Overlay per-participant jitter points for each TLX dimension
for i, label in enumerate(labels):
    arrow_label_vals = [int(combined[i]['arrow_'+label]) for i in combined]
    map_label_vals   = [int(combined[i]['map_'+label])   for i in combined]
    _overlay_jitter(
        ax,
        [arrow_label_vals, map_label_vals],
        [x[i] - width/2, x[i] + width/2],
        [palette[4], palette[5]],
    )
ax.set_xticks(x)
ax.set_xticklabels(labels, rotation=45, ha='right')
ax.set_ylabel('Average Score')
ax.set_title('Task Load Index Comparison')
ax.legend()
fig.tight_layout()
fig.savefig(os.path.join('reports', 'tlx_comparison.png'))
plt.close(fig)

# 3) Summary bar chart: average Understanding vs Difficulty (Arrow vs Map)
avg_arrow_understand = np.mean(arrow_understand) if arrow_understand else 0
avg_map_understand = np.mean(map_understand) if map_understand else 0
avg_arrow_difficulty = np.mean(arrow_difficulty) if arrow_difficulty else 0
avg_map_difficulty = np.mean(map_difficulty) if map_difficulty else 0

categories = ['Understanding', 'Difficulty']
arrow_vals = [avg_arrow_understand, avg_arrow_difficulty]
map_vals = [avg_map_understand, avg_map_difficulty]

x2 = np.arange(len(categories))
width2 = 0.35
fig3, ax3 = plt.subplots(figsize=(8, 5))
ax3.bar(x2 - width2/2, arrow_vals, width2, label='Arrow', color=palette[6], alpha=0.7)
ax3.bar(x2 + width2/2, map_vals, width2, label='Map', color=palette[7], alpha=0.7)
_overlay_jitter(
    ax3,
    [arrow_understand, map_understand],
    [x2[0] - width2/2, x2[0] + width2/2],
    [palette[6], palette[7]],
)
_overlay_jitter(
    ax3,
    [arrow_difficulty, map_difficulty],
    [x2[1] - width2/2, x2[1] + width2/2],
    [palette[6], palette[7]],
)
ax3.set_xticks(x2)
ax3.set_xticklabels(categories)
ax3.set_ylabel('Average Score')
ax3.set_title('Understanding vs Difficulty — Arrow vs Map')
ax3.legend()
fig3.tight_layout()
fig3.savefig(os.path.join('reports', 'summary_understanding_difficulty.png'))
plt.close(fig3)