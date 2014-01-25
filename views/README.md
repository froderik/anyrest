# anyrest

A resource agnostic rest service that runs in memory.

Background
==========

The idea of this little thing came about when reading the [testing katas](http://www.soapui.org/Testing-Katas/what-are-testing-katas.html) created by [SmartBear](http://smartbear.com/) - my current client. The katas describe how to test a REST API. Something real and simple to install to run the tests against would be nice. On a further line I also started thinking about how easy it is to build a resource agnostic REST service with sinatra so there - two good reasons to spend a couple of hours to build anyrest.

Apart from using this for testing you could also use it for prototyping a REST service and having it there while developing the real thing.

Prerequisites
=============

To run this server you'll need to have [Ruby installed](https://www.ruby-lang.org/en/downloads/). I used MRI version 2.0.0 when building it but it would probably run with any Ruby 1.9+. 

Setting it up if you know what you are doing
============================================

- clone the repo
- install them gems
- `ruby anyrest.rb`

Setting it up if you are new to ruby 
====================================

Fire up a command line. (Not sure how this works on windows - please add instructions if you know how to.)

    git clone git@github.com:froderik/anyrest.git
    cd anyrest
    bundle install
    ruby anyrest.rb

Using it
========

Here are some examples using `curl` - an awesome command line tool for HTTP interactions. You can use any other way of communicating with REST of course. For example there is [SoapUI](http://www.soapui.org/) if you like a graphical interface or [mechanize](http://mechanize.rubyforge.org/) if you are a Ruby man.

Adding an item
--------------

    > curl --data "name=ruby&dynamic=yes&degreeofoo=5" http://localhost:4567/languages
    335d2f7b-4da5-40b2-b062-dac575ca730b

Curl makes a post by default when there is `--data`. The service returns the id of the newly created item. Lets add another item:

    > curl --data "name=java&dynamic=no&degreeofoo=4" http://localhost:4567/languages
    1062c281-e3df-4d77-bd3e-e973b670e52d

Now we have two language items in the store.

Getting an item
---------------

    > curl http://localhost:4567/languages/1062c281-e3df-4d77-bd3e-e973b670e52d
    {"name":"java","dynamic":"no","degreeofoo":"4"}

The service returns the inserted datas as a JSON Hash.

Getting a list of items for a resource
--------------------------------------

    > curl http://localhost:4567/languages
    {
      "languages§335d2f7b-4da5-40b2-b062-dac575ca730b": {"name":"ruby","dynamic":"yes","degreeofoo":"5"},
      "languages§1062c281-e3df-4d77-bd3e-e973b670e52d": {"name":"java","dynamic":"no","degreeofoo":"4"}
    }

And a JSON Hash with ids as keys and specific hashes for each item as values. Note that the id contains both the resource name and the specific id separated with a §. You need to split this up to use the id in a GET or PUT.

Updating an item
----------------

Updating is done with PUT. This is similar to creating an item. We just add the id to the URL and tell curl to do a PUT instead.

    > curl --data "name=java&dynamic=no&degreeofoo=4" http://localhost:4567/languages/1062c281-e3df-4d77-bd3e-e973b670e52d

Deleting
--------

Finally we need deleting. It is similar to GET so don't mess them up!

    > curl --request DELETE http://localhost:4567/languages/1062c281-e3df-4d77-bd3e-e973b670e52d

It is also possible to delete all items for a resouece:

    > curl --request DELETE http://localhost:4567/languages

and finally all items for all resources:

    > curl --request DELETE http://localhost:4567

Might be useful in teardowns of automated tests.

Ideas
=====

This has been a fast hack. If someone likes it feel free to pull requeset if you want any changes in. Things I thought about maybe doing is:

- make it posible to search for items for a resource with a query string to the resource getter
- define the resources that are available

Testing anyrest
===============

If you'd like to contribute make sure to add tests to `anyrest_test.rb` and make sure that the old ones don't break. They are easily run with `ruby anyrest_test.rb`.