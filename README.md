# Women's Directory

This application hosts [https://womensdirectory.org](womensdirectory.org).

# Environment Variables

| Key                   | Description                                                                          |
| --------------------- | ------------------------------------------------------------------------------------ |
| `APP_DOMAIN`          | The domain used to generate URLs for the application (usually `womensdirectory.org`) |
| `GOOGLE_MAPS_API_KEY` | The API key for the Google Cloud project with access to geocoding                    |
| `INSECURE`            | If set, uses HTTP for URLs; if unset (default), uses HTTPS                           |
| `SENDGRID_API_KEY`    | The API key for sending emails via [SendGrid](https://sendgrid.com/)                 |
