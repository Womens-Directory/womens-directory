<a href="https://womensdirectory.org">
  <img src="app/assets/images/logo.svg" width="200" />
</a>

# [Women's Directory](https://womensdirectory.org)

Women's Directory is a non-profit organization. Our website shows women in need where they can find help and critical resources in their communities.

This Rails app runs the Women's Directory [production website](https://womensdirectory.org).

# Features

- Users can browse for locations that offer services helpful to women in need.
- Locations are categorized (for example: shelters, food banks) so that women can quickly find what they need.
- The app has three main views:
  - The homepage presents a complete list of categories.
  - The category page shows a list of all the locations that belong to that category.
  - The location page presents information about the location, such as location and contact information.
- Users can submit feedback via the button located in the bottom-right corner of all pages. Feedback is sent to a configurable Discord channel for admins to review, and stored in the database.
- Admin tools are available only once an admin user has signed in via `/users/sign_in`. They include:
  - [Rails Admin dashboard](https://github.com/railsadminteam/rails_admin)
  - [Comfy CMS](https://github.com/comfy/comfortable-mexican-sofa)
  - [Birdseye](app/controllers/admin/birdseye_controller.rb)

# Installation

WD uses Ruby 3.0.0, Node 16.14.0 and Postgres 14.

Start your Postgres server locally. On Mac, [Postgres.app](https://postgresapp.com) is a good option.

Install dependencies, prepare the assets, and create and seed the database:

```bash
bundle install
rails yarn:install
rails assets:precompile
rails db:setup
```

# Usage

Start the server:

```bash
rails server
```

The database has already been seeded with demo categories and locations, as well as an admin user.

Sign into the app at [localhost:3000/users/sign_in](http://localhost:3000/users/sign_in).
Use the email address `dev@womensdirectory.org` to sign in as an admin.

Once you have signed in, go back to the homepage. The admin tools will be available under the **Admin** dropdown in the nav bar.

# Deployment

This app is owned by the Women's Directory team in DigitalOcean. It is deployed as a [DigitalOcean App](https://docs.digitalocean.com/products/app-platform).

Commits that land in the `main` branch are automatically deployed to production. The DigitalOcean App Platform watches for these commits. It builds a new image using [Buildpack](https://docs.digitalocean.com/products/app-platform/concepts/buildpack/). It starts a new container from this image which replaces the previous WD container.

If you land code that includes database migrations, you must run them manually in the DigitalOcean console. After the new instance is live in production, go to the App's [console](https://docs.digitalocean.com/products/app-platform/concepts/console/) and run `rails db:migrate`.

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
# Deployment

This app is deployed by the WD team, as a DigitalOcean app. See docs for Digital Ocean https://docs.digitalocean.com/products/app-platform/


# Environment Variables

| Key                   | Description                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| `APP_DOMAIN`          | The domain where the application lives (currently `womens-directory-kgjo4.ondigitalocean.app`)       |
| `DISCORD_WEBHOOK_URL` | The URL for a Discord channel's webhook, used for forwarding website feedback to WD staff            |
| `EMAIL_DOMAIN`        | The send-from domain used for emails, authorized for use in SendGrid (usually `womensdirectory.org`) |
| `GOOGLE_MAPS_API_KEY` | The API key for the Google Cloud project with access to geocoding                                    |
| `INSECURE`            | If set, uses HTTP for URLs; if unset (default), uses HTTPS                                           |
| `SENDGRID_API_KEY`    | The API key for sending emails via [SendGrid](https://sendgrid.com/)                                 |

## Support

Problems, suggestions, or contributions? Please [open an issue](https://github.com/AARodgers/womens-directory/issues) or [submit a pull request](https://github.com/AARodgers/womens-directory/pulls).
