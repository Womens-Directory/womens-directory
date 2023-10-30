<a href="https://womensdirectory.org">
  <img src="app/assets/images/logo.svg" width="200" />
</a>

# [Women's Directory](https://womensdirectory.org)

Women's Directory is a non-profit organization. Our website shows women in need where they can find help and critical resources in their communities.

This Rails app runs the Women's Directory [production website](https://womensdirectory.org).

# Contributors

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-3-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/katjimeno"><img src="https://avatars.githubusercontent.com/u/13637435?v=4?s=100" width="100px;" alt="katjimeno"/><br /><sub><b>katjimeno</b></sub></a><br /><a href="https://github.com/Womens-Directory/womens-directory/commits?author=katjimeno" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://mplewis.com/"><img src="https://avatars.githubusercontent.com/u/1829094?v=4?s=100" width="100px;" alt="Matt Lewis"/><br /><sub><b>Matt Lewis</b></sub></a><br /><a href="https://github.com/Womens-Directory/womens-directory/commits?author=mplewis" title="Code">💻</a> <a href="#infra-mplewis" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://aarodgers.com/"><img src="https://avatars.githubusercontent.com/u/48111009?v=4?s=100" width="100px;" alt="Amanda Rodgers"/><br /><sub><b>Amanda Rodgers</b></sub></a><br /><a href="https://github.com/Womens-Directory/womens-directory/commits?author=AARodgers" title="Code">💻</a> <a href="#content-AARodgers" title="Content">🖋</a> <a href="#business-AARodgers" title="Business development">💼</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

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

# Environment Variables

| Key                   | Description                                                                                          |
| --------------------- | ---------------------------------------------------------------------------------------------------- |
| `APP_DOMAIN`          | The domain where the application lives (currently `womens-directory-kgjo4.ondigitalocean.app`)       |
| `DISCORD_WEBHOOK_URL` | The URL for a Discord channel's webhook, used for forwarding website feedback to WD staff            |
| `EMAIL_DOMAIN`        | The send-from domain used for emails, authorized for use in SendGrid (usually `womensdirectory.org`) |
| `GOOGLE_MAPS_API_KEY` | The API key for the Google Cloud project with access to geocoding                                    |
| `INSECURE`            | If set, uses HTTP for URLs; if unset (default), uses HTTPS                                           |
| `SENDGRID_API_KEY`    | The API key for sending emails via [SendGrid](https://sendgrid.com/)                                 |

# Permissions

Roles are created in [user.rb](app/models/user.rb). They are stored in a Postgres `bigint` (8 bytes) as an ordered bitfield, so do not reorder existing roles!

Roles are granted abilities which allow them to access specific kinds of data and perform specific operations. For example, a `superadmin` is allowed to do anything; a `data_contributor` is only allowed to create some kinds of records. Abilities are granted permissions in [ability.rb](app/models/ability.rb).

Superadmins can manage permissions for non-superadmin users at [`/admin/user_permissions`](http://localhost:3000/admin/user_permissions).

# Support

Problems, suggestions, or contributions? Please [open an issue](https://github.com/AARodgers/womens-directory/issues) or [submit a pull request](https://github.com/AARodgers/womens-directory/pulls).
