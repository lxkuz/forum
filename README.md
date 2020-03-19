# FORUM FEATURES LIST

### Docker

Docker composed container including next containers:
* Rails application
* Sidekiq
* Postgres
* Redis

To start docker run:

```bash
docker-compose build
docker-compose up -d
```
and open http://localhost:3000 in web browser

### Heroku

Application deployed on heroku: https://forumlxkuz.herokuapp.com/
It includes:
* web and worker dynos
* Postgres, Redis and Crontab addons
* Transaction autoclean job works 1 time per hour there

### Data seed

Merchants loaded from seed rake task. Initial loads from S&P-500 companies CSV.
It happens automatically during starting container. Seeds are applying only in case there are no merchants yet in database.

### Merchants UI

Includes:

* Login page powered by Devise gem
Locally: http://localhost:3000/users/sign_in
On Heroku: https://forumlxkuz.herokuapp.com/users/sign_in

Admin login credentials:
*Email: `admin@forum.lxkuz`*
*Password: `forumadmin`*

* Merchants index page includes Bootstrap base CSS styles and Kaminari paginaiton

Locally: http://localhost:3000/
On Heroku: https://forumlxkuz.herokuapp.com/

* Merchants edit page includes transactions list

Locally: http://localhost:3000/merchants/<ID>/edit
On Heroku: https://forumlxkuz.herokuapp.com/merchants/<ID>/edit

### Transaction API

This API has 2 endpoints:

- Getting JWT token. 
Request example:

```bash
curl -X POST \
  https://forumlxkuz.herokuapp.com/api/v1/login \
  -H 'content-type: multipart/form-data'\
  -F email=admin@forum.lxkuz \
  -F password=forumadmin \
  -F 'customer[phone]=12312323' \
  -F 'customer[email]=some@erm.ew'
```
Response sample:

```bash
{
  "token": <JWT_TOKEN>,
  "exp":1585240865
}
```
Lifetime of the token is 7 days. Then the token can be used for posting payment transactions. Request example:
 
```bash
curl -X POST \
  https://forumlxkuz.herokuapp.com/api/v1/payments \
  -H 'authorization: Bearer <JWT_TOKEN>' \
  -H 'content-type: multipart/form-data' \
  -F amount=20.2 \
  -F type=authorize \
  -F uuid=<MERCHANT_ID>
```
Possible types: `authorize`, `charge`, `refund`, `reversal`

Successful response:
```json
{
  "success": true
}
```
Errored response:

```json
{
  "errors": ...
}
```

### Sidekiq

Transactions garbage collector works 1 time per hour. It uses ActiveJob with Sidekiq.
Sidekiq has it's own UI to check jobs statuses:

Locally: http://localhost:3000/sidekiq
On Heroku: https://forumlxkuz.herokuapp.com/sidekiq

### Use cases, presenters, query object, services etc.

* STI used for Transactions classes
* Custom validation used for both User and Transaction models
* Accountant + all payment use cases to handle create Transaction API logic
* LoadMerchant, LoadMerchants, LoadTransactions query objects to handle merchants_controller logic
* MerchantPresenter and TransactionPresenter for rendering merchants index/edit UI
* CollectGarbage service and CollectGarbageJob help to remove old transactions

### Rubocop

Rubocop linter added to the project. To run it try:

```bash
docker-compose exec app rubocop .
```

