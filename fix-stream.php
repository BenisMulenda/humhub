<?php

use humhub\modules\activity\models\Activity;

require_once(__DIR__ . '/protected/humhub/config/cli.php');

$brokenActivities = Activity::find()->all();
$count = 0;

foreach ($brokenActivities as $activity) {
    try {
        $content = $activity->getContent();
        if (!$content || !$content->one()) {
            echo "Deleting broken activity ID: {$activity->id}\n";
            $activity->delete();
            $count++;
        }
    } catch (\Throwable $e) {
        echo "Force-deleting activity ID: {$activity->id} due to error: {$e->getMessage()}\n";
        $activity->delete();
        $count++;
    }
}

echo "✅ Done. Deleted $count broken activity items.\n";
