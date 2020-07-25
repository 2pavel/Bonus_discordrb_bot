# frozen_string_literal: true

require 'discordrb'
require 'wikipedia'

bot = Discordrb::Commands::CommandBot.new token: 'NzMzNzE3MzU3NTE5OTYyMTQ1.XxHRqQ.Z9mEr39FCvEsTBRUxiMFX45tcgY',
                                          client_id: 733717357519962145,
                                          prefix: '$'

bot.message(with_text: 'na łazarskim rejonie') do |event|
  event.respond 'nie jest kolorowo'
end

bot.message(contains: /lufa/i) do |event|
  event.respond ':face_vomiting:'
end

bot.command :random do |_event, min, max|
  rand(min.to_i..max.to_i)
end

bot.command :user do |event|
  username = event.user.name
  u_id = event.user.id
  event.respond "Nickname: #{username}\nid: #{u_id}"
end

CROSS_EMOJI = "\u274c"
bot.message(content: '$time') do |event|
  dzien = Time.now.strftime('%w')
  dzien = case dzien.to_i
          when 0
            'Niedziela'
          when 1
            'Poniedziałek'
          when 2
            'Wtorek'
          when 3
            'Środa'
          when 4
            'Czwartek'
          when 5
            'Piątek'
          when 6
            'SZÓSTY DZIEŃ TYGODNIA!!!'
          end
  message = event.respond "Byku tera jest #{dzien} #{Time.now.strftime('%F %T %Z')}"

  message.react CROSS_EMOJI

  bot.add_await(:"delete_#{message.id}", Discordrb::Events::ReactionAddEvent, emoji: CROSS_EMOJI) do |react_event|
    next true unless react_event.message.id == message.id

    message.delete
  end
end

bot.command(:eval, help_available: false) do |event, *code|
  break unless event.user.id == 142608299899092992

  begin
    eval code.join(' ')
  rescue StandardError
    'Łazarski gladiator nie podołał :face_vomiting:'
  end
end

bot.mention do |event|
  event.user.pm('Nie, nie zawalczę z Tobą na fame MMA XD')
end

bot.command(:connect) do |event|
  channel = event.user.voice_channel
  next 'No nie widzę gdzie Ty jesteś...' unless channel

  bot.voice_connect channel
  "Wbiłem na #{channel.name}"
end

bot.command(:wiki) do |event, *search|
  page = Wikipedia.find(search.map(&:capitalize).join(' '))
  page.fullurl
end

at_exit { bot.stop }
bot.run
