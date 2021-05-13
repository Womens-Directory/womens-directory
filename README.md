# Women's Directory

This application hosts [https://womensdirectory.org](womensdirectory.org).

# Environment Variables

| Key                   | Description                                                                          |
| --------------------- | ------------------------------------------------------------------------------------ |
| `ADMIN_PASSWORD`      | The single password used to access the admin console (username is `wd`)              |
| `APP_DOMAIN`          | The domain used to generate URLs for the application (usually `womensdirectory.org`) |
| `GOOGLE_MAPS_API_KEY` | The API key for the Google Cloud project with access to geocoding                    |
| `INSECURE`            | If set, uses HTTP for URLs; if unset (default), uses HTTPS                           |
