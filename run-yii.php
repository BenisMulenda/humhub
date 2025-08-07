<?php

chdir(__DIR__); // Go to HumHub root

$commands = [
    './protected/yii integrity/run',
    './protected/yii cron/run',
    './protected/yii queue/run',
    './protected/yii search/rebuild',
    './protected/yii cache/flush-all'
];

echo "<pre>";
foreach ($commands as $command) {
    echo ">>> Running: $command\n";
    passthru($command, $exitCode);
    echo "Exit Code: $exitCode\n\n";
}
echo "</pre>";
