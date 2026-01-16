import csv
import os
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

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

def plot_difficulty_boxplot(arrow_difficulty, map_difficulty, reports_dir='reports'):
    os.makedirs(reports_dir, exist_ok=True)
    fig, ax = plt.subplots()
    bplot = ax.boxplot(
        [arrow_difficulty, map_difficulty],
        tick_labels=['Arrow', 'Map'],
        patch_artist=True,
    )
    colors = [palette[0], palette[1]]
    for patch, color in zip(bplot['boxes'], colors):
        patch.set_facecolor(color)
        patch.set_alpha(0.6)
    for median in bplot['medians']:
        median.set_color('#333333')
    _overlay_jitter(ax, [arrow_difficulty, map_difficulty], [1, 2], colors)
    ax.set_ylabel('Score')
    ax.set_title('How hard was it to execute a single navigation instruction?')
    ax.legend(
        [Patch(facecolor=colors[0], alpha=0.6), Patch(facecolor=colors[1], alpha=0.6)],
        ['Arrow', 'Map'],
        loc='upper left'
    )
    fig.savefig(os.path.join(reports_dir, 'difficulty_boxplot.png'))
    plt.close(fig)


def plot_understanding_boxplot(arrow_understand, map_understand, reports_dir='reports'):
    os.makedirs(reports_dir, exist_ok=True)
    fig, ax = plt.subplots()
    bplot = ax.boxplot(
        [arrow_understand, map_understand],
        tick_labels=['Arrow', 'Map'],
        patch_artist=True,
    )
    colors = [palette[2], palette[3]]
    for patch, color in zip(bplot['boxes'], colors):
        patch.set_facecolor(color)
        patch.set_alpha(0.6)
    for median in bplot['medians']:
        median.set_color('#333333')
    _overlay_jitter(ax, [arrow_understand, map_understand], [1, 2], colors)
    ax.set_ylabel('Score')
    ax.set_title('How well did you understand the navigation instructions?')
    ax.legend(
        [Patch(facecolor=colors[0], alpha=0.6), Patch(facecolor=colors[1], alpha=0.6)],
        ['Arrow', 'Map'],
        loc='upper left'
    )
    fig.savefig(os.path.join(reports_dir, 'understanding_boxplot.png'))
    plt.close(fig)


def plot_tlx_comparison(combined, labels, reports_dir='reports'):
    os.makedirs(reports_dir, exist_ok=True)
    count = len(combined)
    arrow_scores = {}
    map_scores = {}
    for label in labels:
        arrow_total = sum(int(combined[i]['arrow_'+label]) for i in combined)
        map_total   = sum(int(combined[i]['map_'+label])   for i in combined)
        arrow_scores[label] = arrow_total / count if count else 0
        map_scores[label] = map_total / count if count else 0

    x = np.arange(len(labels))
    width = 0.35
    fig, ax = plt.subplots(figsize=(10, 5))
    ax.bar(x - width/2, list(arrow_scores.values()), width, label='Arrow TLX', color=palette[4], alpha=0.7)
    ax.bar(x + width/2, list(map_scores.values()), width, label='Map TLX', color=palette[5], alpha=0.7)
    for i, label in enumerate(labels):
        arrow_label_vals = [int(combined[k]['arrow_'+label]) for k in combined]
        map_label_vals   = [int(combined[k]['map_'+label])   for k in combined]
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
    fig.savefig(os.path.join(reports_dir, 'tlx_comparison.png'))
    plt.close(fig)


def plot_summary_understanding_difficulty(arrow_understand, map_understand, arrow_difficulty, map_difficulty, reports_dir='reports'):
    os.makedirs(reports_dir, exist_ok=True)
    avg_arrow_understand = np.mean(arrow_understand) if arrow_understand else 0
    avg_map_understand = np.mean(map_understand) if map_understand else 0
    avg_arrow_difficulty = np.mean(arrow_difficulty) if arrow_difficulty else 0
    avg_map_difficulty = np.mean(map_difficulty) if map_difficulty else 0

    categories = ['Understanding', 'Difficulty']
    arrow_vals = [avg_arrow_understand, avg_arrow_difficulty]
    map_vals = [avg_map_understand, avg_map_difficulty]

    x = np.arange(len(categories))
    width = 0.35
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.bar(x - width/2, arrow_vals, width, label='Arrow', color=palette[6], alpha=0.7)
    ax.bar(x + width/2, map_vals, width, label='Map', color=palette[7], alpha=0.7)
    _overlay_jitter(
        ax,
        [arrow_understand, map_understand],
        [x[0] - width/2, x[0] + width/2],
        [palette[6], palette[7]],
    )
    _overlay_jitter(
        ax,
        [arrow_difficulty, map_difficulty],
        [x[1] - width/2, x[1] + width/2],
        [palette[6], palette[7]],
    )
    ax.set_xticks(x)
    ax.set_xticklabels(categories)
    ax.set_ylabel('Average Score')
    ax.set_title('Understanding vs Difficulty — Arrow vs Map')
    ax.legend()
    fig.tight_layout()
    fig.savefig(os.path.join(reports_dir, 'summary_understanding_difficulty.png'))
    plt.close(fig)


def plot_task_results(map1_results, map2_results, arrow1_results, arrow2_results, reports_dir='reports'):
    os.makedirs(reports_dir, exist_ok=True)
    fig, ax = plt.subplots(figsize=(10, 6))
    groups = [map1_results, map2_results, arrow1_results, arrow2_results]
    labels = ['Map 1', 'Map 2', 'Arrow 1', 'Arrow 2']
    bplot = ax.boxplot(groups, tick_labels=labels, patch_artist=True)
    colors = [palette[0], palette[1], palette[2], palette[3]]
    for patch, color in zip(bplot['boxes'], colors):
        patch.set_facecolor(color)
        patch.set_alpha(0.6)
    for median in bplot['medians']:
        median.set_color('#333333')
    positions = list(range(1, len(groups) + 1))
    _overlay_jitter(ax, groups, positions, colors)
    ax.set_ylabel('Result')
    ax.set_title('Task Results: Map1 / Map2 / Arrow1 / Arrow2')
    ax.legend(
        [Patch(facecolor=c, alpha=0.6) for c in colors],
        labels,
        loc='upper left'
    )
    fig.tight_layout()
    fig.savefig(os.path.join(reports_dir, 'task_results_boxplots.png'))
    plt.close(fig)


def _coerce_val_for_dist(v):
    try:
        fv = float(v)
        iv = int(round(fv))
        if np.isclose(fv, iv):
            return iv
        return round(fv, 2)
    except Exception:
        return v


def _compute_stats(values):
    vals = [v for v in values if v is not None]
    if not vals:
        return {
            'count': 0,
            'avg': float('nan'),
            'min': float('nan'),
            'max': float('nan'),
            'distribution': {},
        }
    avg = float(np.mean(vals))
    mn = float(np.min(vals))
    mx = float(np.max(vals))
    dist = {}
    for v in vals:
        k = _coerce_val_for_dist(v)
        dist[k] = dist.get(k, 0) + 1
    try:
        dist = dict(sorted(dist.items(), key=lambda kv: kv[0]))
    except Exception:
        pass
    return {
        'count': len(vals),
        'avg': avg,
        'min': mn,
        'max': mx,
    }


def _print_series_summary(name, stats):
    print(f"{name}: count={stats['count']}, avg={stats['avg']:.2f}, min={stats['min']:.2f}, max={stats['max']:.2f}")


with open('combined.csv', newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    combined = {row[reader.fieldnames[0]]: row for row in reader}

arrow_difficulty = [float(combined[i].get('arrow_difficulty')) for i in combined]
map_difficulty   = [float(combined[i].get('map_difficulty'))   for i in combined]
arrow_understand = [float(combined[i].get('arrow_understanding')) for i in combined]
map_understand   = [float(combined[i].get('map_understanding'))   for i in combined]

plot_difficulty_boxplot(arrow_difficulty, map_difficulty)
plot_understanding_boxplot(arrow_understand, map_understand)

labels = [
    "mental_demand",
    "physical_demand",
    "temporal_demand",
    "performance",
    "effort",
    "frustration"
]
plot_tlx_comparison(combined, labels)

plot_summary_understanding_difficulty(
    arrow_understand,
    map_understand,
    arrow_difficulty,
    map_difficulty,
)

def _num_list(field):
    vals = []
    for k in combined:
        v = combined[k].get(field, '')
        if v is None:
            continue
        v = str(v).strip()
        if v == '':
            continue
        try:
            vals.append(float(v))
        except ValueError:
            continue
    return vals

map1_results = _num_list('map1_result')
map2_results = _num_list('map2_result')
arrow1_results = _num_list('arrow1_result')
arrow2_results = _num_list('arrow2_result')
plot_task_results(map1_results, map2_results, arrow1_results, arrow2_results)

print("\n=== Console Summary ===")

print("\n-- Understanding --")
_print_series_summary("Arrow Understanding", _compute_stats(arrow_understand))
_print_series_summary("Map Understanding", _compute_stats(map_understand))

print("\n-- Difficulty --")
_print_series_summary("Arrow Difficulty", _compute_stats(arrow_difficulty))
_print_series_summary("Map Difficulty", _compute_stats(map_difficulty))


print("\n-- TLX --")
for _lbl in labels:
    arrow_vals = [int(combined[k]['arrow_'+_lbl]) for k in combined]
    map_vals   = [int(combined[k]['map_'+_lbl])   for k in combined]
    _print_series_summary(f"Arrow TLX — {_lbl}", _compute_stats(arrow_vals))
    _print_series_summary(f"Map TLX — {_lbl}", _compute_stats(map_vals))

print("\n-- Task Results --")
_print_series_summary("Map 1 Result", _compute_stats(map1_results))
_print_series_summary("Map 2 Result", _compute_stats(map2_results))
_print_series_summary("Arrow 1 Result", _compute_stats(arrow1_results))
_print_series_summary("Arrow 2 Result", _compute_stats(arrow2_results))