# Women's Directory
![Logo](https://raw.githubusercontent.com/AARodgers/womens-directory4ce1c893aff59293e3ebb65546cad5f001ee8594/app/assets/images/logo.svg?token=ALPB3ILGDIJN4QLLKZUH5L3CEZIBI)

This application hosts [https://womensdirectory.org](womensdirectory.org).

# Environment Variables

| Key                   | Description                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| `APP_DOMAIN`          | The domain where the application lives (currently `womens-directory-kgjo4.ondigitalocean.app`)       |
| `EMAIL_DOMAIN`        | The send-from domain used for emails, authorized for use in SendGrid (usually `womensdirectory.org`) |
# can we use SendGrid for emails?
| `GOOGLE_MAPS_API_KEY` | The API key for the Google Cloud project with access to geocoding                                    |
| `INSECURE`            | If set, uses HTTP for URLs; if unset (default), uses HTTPS                                           |
| `SENDGRID_API_KEY`    | The API key for sending emails via [SendGrid](https://sendgrid.com/)                                 |
