# Demo project

This is a simple demo project meant to take a user on a bit of a product tour. 

## Testing the demo on Upsun

### Part 1: Replicating what is provided in Console

1. Clone the repository, and create an organization and a project on Upsun we'll deploy it to:

- ```
  git clone git@github.com:platformsh/demo-project.git upsun-demo && cd upsun-demo
  ```
- ```
  upsun organization:create --label "Upsun Testing" --name upsun-testing
  ```
- ```
  upsun create --org upsun-testing --title "Upsun demo" --region "org.recreation.plat.farm" --plan flexible --default-branch main --no-set-remote -y
  ```

2. Set the remote for the project, and first push:

- ```
  PROJECT_ID=$(upsun project:list --title "Upsun demo" --pipe)
  ```
- ```
  upsun project:set-remote $PROJECT_ID
  ```
- ```
  upsun push -y
  ```

> [!IMPORTANT]
> This first push will take a moment to build _and_ will fail.
> This is expected, so follow the next step (3) to setup the initial resources.

3. Configure resources for production, and verify the deployment:

- ```
  upsun resources:set --size '*:1'
  ```
- ```
  upsun url --primary
  ```

### Part 2: Listing what is described within the Demo Project

The steps below are provided for you within the deployed environment.
They are listed here just in case you get lost.

1. Create a staging (preview) environment:

- ```
  upsun branch staging --type staging
  ```
- ```
  upsun url --primary
  ```

2. Push a Redis service

  Uncomment the `backend.relationships` and `services` block in `.upsun/config.yaml`, so it looks like the following:

  ```yaml
  #####################################################################################
  # Step 3: Add a service. Uncomment this section.
  #####################################################################################
          relationships:
              redis_session: "redis_persistent:redis"

  services:
    redis_persistent:
        type: "redis-persistent:7.0"
  #####################################################################################
  ```

  Commit that change, push, and define resources for the change:

  - ```
    git commit -am 'Add Redis service and relationship.'
    ```
  - ```
    upsun push
    ```
  - ```
    upsun resources:set --size redis_persistent:0.5 --disk redis_persistent:512
    ```

3. Merge the preview environment into production:

- ```
  git checkout main
  ```
- ```
  upsun merge staging
  ```
- ```
  upsun resources:set --size redis_persistent:0.5 --disk redis_persistent:512
  ```

> [!IMPORTANT]
> Post-merge, you _do_ need to _redefine_ resources for Redis on the production environment, as shown above.

4. Scale the backend app container (Python):

- ```
  upsun resources:set --count backend:3
  ```

> [!IMPORTANT]
> This final change should produce a "Demo complete" page to the user.
> The transition is still in testing for reliability. 

## Using this project locally

There is a root package `@platformsh/demo-project` that controls both the backend and frontend app setup.
NPM is required. 

1. `git clone git@github.com:platformsh/demo-project.git`
1. `cd demo-project`
1. `npm install`
1. `npm run start`

These commands will set up everything you need to get started, serving:

- The `backend` Python app from `localhost:8000`
- The `frontend` React app from `localhost:3000`

> [!IMPORTANT]
> If at any time you want to start over, run `npm run clean`.
> This will delete everything you've done in the previous steps.