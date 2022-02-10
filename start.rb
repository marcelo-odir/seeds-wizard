#!/usr/bin/env ruby

require 'tty-prompt'
require 'tty-progressbar'
require 'csv'
require './seeds'

ficheiro = "./out.csv"
prompt = TTY::Prompt.new
seed = Seed.new

numCol = prompt.ask("Quantas colunas irá ter ?", convert: :integer) do |q|
    q.convert :integer
    q.messages[:convert?] = "O valor acima precisa ser um número inteiro"
end

header = []
tipos = []
numCol.times do |i|
    entrada = prompt.ask("Entre com a descrição #{i}:")
    header << entrada
    tipo = prompt.select("Entre com o tipo do campo #{i}:", seed.list)
    tipos << tipo
end

qteRegister = prompt.ask("Entre com quantidade de registros: ", convert: :integer) do |q|
    q.convert :integer
    q.messages[:convert?] = "O valor acima precisa ser um número inteiro"
end

bar = TTY::ProgressBar.new("a processar... [:bar] ET::elapsed ETA::eta :rate/s :percent", total: qteRegister)


CSV.open(ficheiro, "wb") do |csv|
    csv << header
    qteRegister.times do
        bar.advance
        linha = []
        tipos.each do |tipo|
            linha << seed.select(tipo)
        end
        csv << linha
    end
end

puts "Ficheiro criado."