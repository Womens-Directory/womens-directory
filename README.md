[<img src="app/assets/images/logo.svg" style="max-width: 200px;">](https://womensdirectory.org)

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

Problems, suggestions, or contributions? Please [open an issue](https://github.com/AARodgers/womens-directory/issues) or [submit a pull request](https://github.com/AARodgers/womens-directory/pulls).
