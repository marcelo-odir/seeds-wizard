
#New Fakers can be insert adding new methods in the class Seed above.
# https://github.com/faker-ruby/faker

require 'faker'

class Seed

    def initialize
        Faker::Config.locale = 'pt'
    end

    def name
        #1
        Faker::Name.name
    end

    def email
        #2
        Faker::Internet.email
    end

    def city
        #3
        Faker::Address.city
    end

    def country
        #4
        Faker::Address.country
    end

    def job
        #5
        Faker::Job.title
    end

    def company
        #6
        Faker::Company.name
    end

    def colorName
        #7
        Faker::Color.color_name
    end

    def currencyCode
        #8
        Faker::Currency.code
    end

    def birthday (idadeMinima = 18, idadeMaxima = 70)
        #9
        Faker::Date.birthday(min_age: idadeMinima, max_age: idadeMaxima)
    end

    def avatar
        #10
        Faker::Avatar.image
    end

    def lorem
        #11
        Faker::Lorem.paragraph
    end

    def number (numDigits = 10)
        #12
        Faker::Number.number(digits: numDigits)
    end

    def cellphone
        #13
        Faker::PhoneNumber.cell_phone
    end

    def datetime (dtInitial = DateTime.now - 10, dtFinal = DateTime.now)
        #14
        Faker::Time.between(from: dtInitial, to: dtFinal, format: :short)
    end

    def username
        #15
        Faker::Internet.username
    end

    def password
        #16
        Faker::Internet.password
    end

    def ipv4
        #17
        Faker::Internet.ip_v4_address
    end

    def url
        #18
        Faker::Internet.url
    end

    def userAgent
        #19
        Faker::Internet.user_agent
    end

    def price
        #20
        Faker::Commerce.price 
    end

end