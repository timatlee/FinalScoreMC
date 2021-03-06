@ignorelist = get_value('session.ignorelist')
if(!@ignorelist) {
	@ignorelist = array()
} else {
	clear_value('session.ignorelist')
}
export('ignorelist', @ignorelist)

@conv = get_value('session.conv')
if(!@conv) {
	@conv = array()
} else {
	clear_value('session.conv')
}
export('conv', @conv)

# PMs, ignores, and mutes
bind('player_chat', null, null, @event) {
	include('includes.library/chat.ms')
	if(@event['message'][0] == '@') {
		cancel()
		@p = substr(parse_args(@event['message'])[0], 1)
		if((length(@p) + 2) >= length(@event['message'])) {
			die()
		}
		@message = substr(@event['message'], length(@p) + 2)
		_pmsg(@p, @message)
		console(player().' @ '.@p.': '.@message, false)
		die()
	}
	if(@recipients = _remove_ignored(player(), @event['recipients'])) {
		modify_event('recipients', @recipients)
	} else if(array_size(all_players()) > 1) {
		cancel()
		die('No players can receive your chat.')
	}
	modify_event('message', colorize(@event['message']))
	modify_event('format', color('dark_gray').simple_date('h:mm').' '.if(array_contains(pgroup(), 'donors'), color('green').'\u2666 ')._colorname().player().color('gray').': '.color('r').'%2$s')
}