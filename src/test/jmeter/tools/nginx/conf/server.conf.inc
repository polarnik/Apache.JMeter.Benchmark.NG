    server {
        listen       80;
        server_name  localhost;

        location / {
            root   html;
            index  index.html index.htm;
        }
		
		location /downloadResults/ {
            autoindex on;
        }
		
		location ~ \.php$ {
			#client_max_body_size 2048m;
			root   php;
			fastcgi_pass   127.0.0.1:9123;
			fastcgi_index  index.php;
			fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
			include        fastcgi_params;
			fastcgi_intercept_errors on;
			fastcgi_temp_file_write_size 10m;
		}

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        location /server_status {
            stub_status;
        }

     }