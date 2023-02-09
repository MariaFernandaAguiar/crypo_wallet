namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando DB...") {%x(rails db:drop)}

      show_spinner("Criando BD...") {%x(rails db:create)}

      show_spinner("Migrando BD...") {%x(rails db:migrate)}

      # show_spinner("Populando BD...") {%x(rails db:seed)}
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    
    else
      puts "Você não está em ambiente de desenvolvimento"
    end

  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do
      coins = [
              { description: "Bitcon",
              acronym: "BTC",
              url_image: "https://static.vecteezy.com/system/resources/previews/008/505/801/original/bitcoin-logo-color-illustration-png.png",
              mining_type: MiningType.find_by(acronym: 'PoW')},

              { description: "Ethereum",
              acronym: "ETH",
              url_image: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Ethereum_logo_2014.svg/1257px-Ethereum_logo_2014.svg.png",
              mining_type: MiningType.all.sample},

              { description: "Dash",
              acronym: "DASH",
              url_image: "https://media.dash.org/wp-content/uploads/dash-d.png",
              mining_type: MiningType.all.sample}
          ]

      coins.each do |coin|
          Coin.find_or_create_by!(coin)
      end
    end
  end


  desc "Cadastro de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando mineração...") do
      mining_types = [
        {description:"Proof of work", acronym:"PoW"},
        {description:"Proof of Stake", acronym:"PoS"},
        {description:"Proof of Capacity", acronym:"PoC"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  def show_spinner(msg_start, msg_end = "Concluído!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})") 
  end
end

