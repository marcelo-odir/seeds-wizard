#!/usr/bin/env ruby

require 'tty-prompt'
require 'tty-progressbar'
require 'csv'
require './seeds'

prompt = TTY::Prompt.new
seed = Seed.new

def csv_output(qteRegister, header, tipos, bar, seed, prompt)
    csv_file = "./out.csv"

    CSV.open(csv_file, "wb") do |csv|
        csv << header
        qteRegister.times do
            bar.advance
            linha = []
            tipos.each do |tipo|
                linha << eval("seed.#{tipo}")
            end
            csv << linha
        end
    end
end

def sql_output(qteRegister, headers, tipos, bar, seed, prompt)
    sql_file = "./out.sql"

    tableName = prompt.ask("Entre com o nome da tabela: ")

    #SQL query = INSERT INTO table_name (column1, column2, column3, ...) VALUES (value1, value2, value3, ...);
    slq1de3 = "INSERT INTO #{tableName} ("
    sql2de3 = ") VALUES ("
    sql3de3 = ");"

    out_file = File.new(sql_file, "w")
        qteRegister.times do
            bar.advance

            sql = ""
            sql << slq1de3
            headers.each do |header|
                sql << "#{header}, " if header != headers.last
                sql << "#{header} "  if header == headers.last
            end
            sql << sql2de3
            tipos.each do |tipo|
                sql << "'#{eval("seed.#{tipo}")}', " if tipo != tipos.last
                sql << "'#{eval("seed.#{tipo}")}' "  if tipo == tipos.last
            end
            sql << sql3de3
            out_file.puts(sql)
        end
    out_file.close
end

saida = prompt.select("Entre com o tipo de saida: ", %w"CSV SQL")

numCol = prompt.ask("Quantas colunas irá ter ?", convert: :integer) do |q|
    q.convert :integer
    q.messages[:convert?] = "O valor acima precisa ser um número inteiro"
end

header = []
tipos = []
lista = Seed.instance_methods(false)
lista = lista.map {|x| x.to_s}
lista = lista.sort
numCol.times do |i|
    entrada = prompt.ask("Entre com a descrição #{i}:")
    header << entrada
    tipo = prompt.select("Entre com o tipo do campo #{i}:", lista)
    tipos << tipo
end

qteRegister = prompt.ask("Entre com quantidade de registros: ", convert: :integer) do |q|
    q.convert :integer
    q.messages[:convert?] = "O valor acima precisa ser um número inteiro"
end

bar = TTY::ProgressBar.new("a processar... [:bar] ET::elapsed ETA::eta :rate/s :percent", total: qteRegister)

csv_output(qteRegister, header, tipos, bar, seed, prompt) if saida == 'CSV'

sql_output(qteRegister, header, tipos, bar, seed, prompt) if saida == 'SQL'

puts "Ficheiro criado."