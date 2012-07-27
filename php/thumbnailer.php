<?php
// thumbnailer.php by pdq 03-07-2012

$path_to_script = "${HOME}/bin/thumb.sh";
#$path_to_directory = '/media/truecrypt1/movies';
$path_to_directory = (isset($argv[1]) ? $argv[1] : false);

if (is_dir($path_to_directory))
	try {
		$dir = new RecursiveDirectoryIterator($path_to_directory);
		$it  = new RecursiveIteratorIterator($dir);
		while ($it->valid()) {
			if (!$it->isDot()) {
				$name      = $it->key();
				$file_ext  = strrchr($name, '.');
				$whitelist = array('.avi', '.wmv', '.mkv', '.mp4', '.3gp', '.mpg', '.mpeg', 
								   '.flv', '.m4v', '.mov', '.ogg', '.swf', '.rm', '.webm'); 
				if (in_array($file_ext, $whitelist))
					exec($path_to_script.' '.$name);    
			}
			$it->next();
		}
	}
	catch(Exception $e) {
	echo 'No files found!';
	}
else
	echo "No directory found!\n\nExample use: php path/to/thumbnailer.php /path/to/videos\n\n";
// EndFile
 ?>