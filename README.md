# Women's Directory

![Logo](https://raw.githubusercontent.com/AARodgers/womens-directory/4ce1c893aff59293e3ebb65546cad5f001ee8594/app/assets/images/logo.svg?token=ALPB3ILGDIJN4QLLKZUH5L3CEZIBI)

This application hosts [https://womensdirectory.org](womensdirectory.org).

Women's Directory is a rails app that is used to run the non-profit Women's Directory website. The website is a free resource for women to find critical resources and help within their community.


## Features

- This app allows users to browse different locations that offer services under a set of categories for help, such as shelters.
- WD provides three main views: homepage, category, and location.
- The homepage is located in () and shows the different categories a user can click on to see it's locations.
- Location views are located in () and list the different locations that are in that category.
- A user can click on the location link to see more details about that location such as contact information and location.
- A user can contact the admin via the feedback button located at the bottom right corner of the homepage.
- Feedback is sent to a Discord channel to be reviewed.
- The admin dashboards are Rails Admin and Birdseye. Admin can access them by logging in at https://womensdirectory.org/users/sign_in and then navigating to https://womensdirectory.org/admin once successfully logged in.


## Installation

WD uses Ruby Version Rails 6.1.3.1, Ruby 3.0.0, Node v17.3.1, Yarn 1.22.10

Install this app by running:

```bash
  rails install womens-directory ??
  cd womens-directory
```

WD uses a Postgres database, to set it up run:

```bash
    rails db:create
    rails db:migrate
```

# Environment Variables

| Key                   | Description                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| `APP_DOMAIN`          | The domain where the application lives (currently `womens-directory-kgjo4.ondigitalocean.app`)       |
| `EMAIL_DOMAIN`        | The send-from domain used for emails, authorized for use in SendGrid (usually `womensdirectory.org`) |
# can we use SendGrid for emails?
| `GOOGLE_MAPS_API_KEY` | The API key for the Google Cloud project with access to geocoding                                    |
| `INSECURE`            | If set, uses HTTP for URLs; if unset (default), uses HTTPS                                           |
| `SENDGRID_API_KEY`    | The API key for sending emails via [SendGrid](https://sendgrid.com/)                                 |
