<?php
// В PHP 4.1.0 и более ранних версиях следует использовать $HTTP_POST_FILES
// вместо $_FILES.

$uploaddir = '/tmp/nginx/data/';

print "<pre>";
echo $_FILES['userfile']['tmp_name'];
print "</pre>";


echo '<pre>';
$fileHash = hash_file ( "md5" , $_FILES['userfile']['tmp_name'] );
$uploadfile = $uploaddir . $fileHash . '_' . basename($_FILES['userfile']['name']);
if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)) {
    echo "Файл корректен и был успешно загружен.\n";
} else {
    echo "Возможная атака с помощью файловой загрузки!\n";
}

print "</pre>";

print "<h2>Ссылка на скачивание</h2>";
print "<p><a href=\"data/" . $fileHash . '_' . basename($_FILES['userfile']['name']) . "\">" . $fileHash . '_' . basename($_FILES['userfile']['name']) . "</a></p>";

echo '<pre>';
echo 'Некоторая отладочная информация:';
print_r($_FILES);
print "</pre>";

?>
