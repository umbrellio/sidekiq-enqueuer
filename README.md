# Sidekiq::Enqueuer &middot; [![version](https://badge.fury.io/gh/umbrellio%2Fsidekiq-enqueuer.svg)](https://badge.fury.io/gh/umbrellio%2Fsidekiq-enqueuer) ![build](https://github.com/umbrellio/sidekiq-enqueuer/workflows/build/badge.svg?branch=master) [![coverage](https://coveralls.io/repos/github/umbrellio/sidekiq-enqueuer/badge.svg?branch=master)](https://coveralls.io/github/umbrellio/sidekiq-enqueuer?branch=master)

A Sidekiq Web extension to enqueue/schedule job in Web UI. Support both Sidekiq::Worker and ActiveJob.
Based on [richfisher's sidekiq-enqueuer](https://github.com/richfisher/sidekiq-enqueuer)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "sidekiq-enqueuer"
```

And then execute:

```bash
$ bundle
```

Edit config/initializers/sidekiq.rb, add following line

```ruby
require "sidekiq/enqueuer"
```

Optionally, provide a list of Jobs to display on the new tab, on a new initializer file.
Worry not, when no configuration is provided, all jobs will be displayed.

```ruby
# config/initializers/sidekiq_enqueuer.rb
require "sidekiq/enqueuer"

Sidekiq::Enqueuer.configure do |config|
  # string/symbol literals are used to when you prefer not to resolve job constants
  config.jobs = %w[MyAwesomeJob1 MyModule::MyAwesomeJob2]
  # you can use constants array as well 
  # config.jobs = [MyAwesomeJob1, MyModule::MyAwesomeJob2]
end

```


## Notes:

### Queuing & ActiveJob support
Use default sidekiq queue adapter for Jobs including Sidekiq::Worker or Jobs inheriting from ActiveJob::base.

```ruby
class Application < Rails::Application
  # ...
  config.active_job.queue_adapter = :sidekiq
end
```
https://github.com/mperham/sidekiq/wiki/Active-Job#active-job-setup


### Jobs action param mapping.
This gem dynamically infers the params required in the `perform` or `perform_in` action in your Job / Worker.
It is important those actions (either of them) won't hide the actual params into a single *args one.
In that case it will be impossible to infer the params for your method.

Want to verify this last line? Run this in a rails console:
```ruby
MyJob.instance_method(:perform).parameters            # change :perform for your implemented method
# => [[:req, :param1], [:opt, :param2], [:opt, :param3]]   # Good output => [[:rest, :args], [:block, :block]]   # Bad output. Params are being wrapped into a super class.
```

### Enqueuing Jobs:

For Sidekiq, enqueing is being done using `Sidekiq::Client.enqueue_to` / `enqueue_to_in`, providing Job, and queue extracted from the Job sidekiq_options hash, defaults to 'default' queue when not present.

For ActiveJob, enqueing is being done calling the very own `perform_later` instance method. Please advise your Job should respond to `perform_later` to correctly work.

## Usage

* Open Sidekiq Web, click the `Enqueuer` tab.

* You can see a list of job classes/modules and params. Click Enqueue.

![list](https://cloud.githubusercontent.com/assets/830633/14494297/c9b01b10-01bc-11e6-8ef5-a4d29ff45fb3.png)

* Fill the form, click Enqueue or Schedule.
![form](https://cloud.githubusercontent.com/assets/830633/20659706/e8dde182-b50a-11e6-90e6-022d5c1ae2db.png)

* That is it!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/umbrellio/sidekiq-scheduler.

## License

Released under MIT License.

## Authors

Team Umbrellio & [richfisher](mailto:richfisher.pan@gmail.com)

---

<a href="https://github.com/umbrellio/">
<img style="float: left;" src="https://umbrellio.github.io/Umbrellio/supported_by_umbrellio.svg" alt="Supported by Umbrellio" width="439" height="72">
</a>

