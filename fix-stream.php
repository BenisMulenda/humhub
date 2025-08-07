<?php

// Change path to autoload.php if your structure differs
require_once(__DIR__ . '/protected/vendor/autoload.php');
require_once(__DIR__ . '/protected/humhub/components/Application.php');

$config = require(__DIR__ . '/protected/config/web.php');

// Boot HumHub in CLI-like mode
\Yii::$app = new humhub\components\Application($config);

use humhub\modules\activity\models\Activity;

$count = 0;
$activities = Activity::find()->all();

foreach ($activities as $activity) {
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
