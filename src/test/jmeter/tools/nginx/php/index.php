<!-- Тип кодирования данных, enctype, ДОЛЖЕН БЫТЬ указан ИМЕННО так -->
<form enctype="multipart/form-data" action="upload.php" method="POST">
    <!-- Название элемента input определяет имя в массиве $_FILES -->
	<p>
    <div>Отправить этот файл: <input name="userfile" type="file" /></div>
    <div><input type="submit" value="Send File" /></div>
	</p>
</form>

<h2>Все закачанные файлы</h2>
<a href="/data">data</a>