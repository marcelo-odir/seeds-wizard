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

saida = prompt.select("Switch the output file format: ", %w"CSV SQL")

numCol = prompt.ask("How many column ?", convert: :integer) do |q|
    q.convert :integer
    q.messages[:convert?] = "Please, enter a integer number."
end

header = []
tipos = []
lista = Seed.instance_methods(false)
lista = lista.map {|x| x.to_s}
lista = lista.sort
numCol.times do |i|
    entrada = prompt.ask("Enter the header name #{i+1}:")
    header << entrada
    tipo = prompt.select("Enter the type of column #{i+1}:", lista)
    tipos << tipo
end

qteRegister = prompt.ask("How many record? ", convert: :integer) do |q|
    q.convert :integer
    q.messages[:convert?] = "Please, enter a integer number."
end

bar = TTY::ProgressBar.new("Processing... [:bar] ET::elapsed ETA::eta :rate/s :percent", total: qteRegister)

csv_output(qteRegister, header, tipos, bar, seed, prompt) if saida == 'CSV'

sql_output(qteRegister, header, tipos, bar, seed, prompt) if saida == 'SQL'

puts "file created."