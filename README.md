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

WD uses Ruby 3.0.0, Node 16.14.0 and Postgres 14.

Start your Postgres server locally. On Mac, [Postgres.app](https://postgresapp.com) is a good option.

Install dependencies, prepare the assets, and create and seed the database:

```bash
bundle install
rails yarn:install
rails assets:precompile
rails db:setup
```

## Usage

Start the server:

```bash
rails server
```

The database has already been seeded with demo categories and locations, as well as an admin user.

Sign into the app at [localhost:3000/users/sign_in](http://localhost:3000/users/sign_in).
Use the email address `dev@womensdirectory.org` to sign in as an admin.

Once you have signed in, go back to the homepage. The admin tools will be available under the **Admin** dropdown in the nav bar.

# Deployment

This app is deployed by the WD team, as a DigitalOcean app. See docs for Digital Ocean https://docs.digitalocean.com/products/app-platform/


# Environment Variables

| Key                   | Description                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| `APP_DOMAIN`          | The domain where the application lives (currently `womens-directory-kgjo4.ondigitalocean.app`)       |
| `EMAIL_DOMAIN`        | The send-from domain used for emails, authorized for use in SendGrid (usually `womensdirectory.org`) |
| `GOOGLE_MAPS_API_KEY` | The API key for the Google Cloud project with access to geocoding                                    |
| `INSECURE`            | If set, uses HTTP for URLs; if unset (default), uses HTTPS                                           |
| `SENDGRID_API_KEY`    | The API key for sending emails via [SendGrid](https://sendgrid.com/)                                 |

## Support

Please submit a pull request at https://github.com/AARodgers/womens-directory
