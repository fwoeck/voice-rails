env.i18n =
  en:
    dialog:
      agent_created:    'You successfully added NAME as new ROLE.'
      browser_warning:  'For now, Chrome CHROME+ and Firefox FIREFOX+ are the only supported browsers. Use this platform at own risk.'
      cancel:           'Cancel'
      dial_now:         'Dial now'
      enter_number:     'Enter a number to dial to:'
      form_with_errors: 'One or more fields contain invalid data. Please fill them in correctly and try again.'
      hangup:           'Hangup'
      hangup_this_call: 'Do you want to hangup this call?'
      i_am_busy:        'I\'m busy'
      incoming_call:    'You have an incoming call from<br /><strong>NAME</strong>'
      lost_server_conn: 'Sorry, we lost our connection to the server &mdash;<br />please check your network and try to re-login.'
      no_messages:      'Sorry, we stopped receiving messages &mdash;<br />please open just one app window at a time.'
      ok:               'Ok'
      outgoing_call:    'Do you want to call<br /><strong>NAME</strong>?'
      reload_necessary: 'We need to reload the browser window to activate this setting.'
      reload:           'Reload'
      shortcut_header:  'Keyboard shortcuts'
      take_call:        'Take call'
      transfer_call:    'Do you want to transfer this call to<br /><strong>AGENT</strong>?'
      transfer:         'Transfer'
      yes:              'Yes'
    agents:
      agent_is:         'agent is'
      agents_are:       'agents are'
      available:        'available'
    status:
      away:             'I\'m away from desk.'
      busy:             'I\'m currently busy.'
      ready:            'I\'m ready to take calls.'
      ringing:          'I\'m receiving a call.'
      talking:          'I\'m currently talking.'
    customers:
      customer_is:      'customer is'
      customers_are:    'customers are'
      queued:           'queued'
    crmuser:
      create_ticket:    "Create a #{env.crmProvider} ticket from this call"
      default_subject:  'Ticket for CALL'
      recent_tickets:   "Recent tickets at #{env.crmProvider}"
      request_new_user: "Request a new #{env.crmProvider} user for this customer."
    help:
      A:                'CR:     Confirm current dialog'
      B:                'ESC:    Close current dialog'
      a:                'Ctrl+A: Show the agents page'
      b:                'Ctrl+B: Set my state to "busy"'
      d:                'Ctrl+D: Show the dashboard'
      f:                'Ctrl+F: Filter the agent list'
      h:                'Ctrl+H: Hangup the current call'
      i:                'Ctrl+I: Show this shortcut list'
      j:                'Ctrl+J: Show/hide foreign calls'
      m:                'Ctrl+M: Type a chat message'
      o:                'Ctrl+O: Dial an outbound number'
      r:                'Ctrl+R: Set my state to "ready"'
      s:                'Ctrl+S: Show the stats page'
    domain:
      agent:            'Agent'
      answered_at:      'Answered at'
      availability:     'Availability'
      called_at:        'Called At'
      caller_id:        'Caller Id'
      clear:            'Clear'
      email:            'E-Mail'
      full_name:        'Full Name'
      language_choice:  'Language Choice'
      language:         'Language'
      languages:        'Languages'
      line:             'Line'
      logout:           'Logout'
      mailbox:          'Mailbox'
      old_password:     'Old Password'
      password:         'New Password'
      confirmation:     'Password Confirmation'
      queued_at:        'Queued At'
      remarks:          'Remarks'
      roles:            'Roles'
      requested_skill:  'Requested Skill'
      save_record:      'Save Record'
      save_changes:     'Save Changes'
      sip_extension:    'SIP Extension'
      sip_secret:       'SIP Password'
      skills:           'Skills'
      user:             'user'
      crmuser_id:       "#{env.crmProvider} Id"
    headers:
      agent_management: 'Agent Management'
      agent_overview:   'Agent Overview'
      agent_profile:    'Agent Profile'
      agent_table:      'Agent Table'
      agent_list:       'Agent List'
      callcenter_stats: 'Call Center Statistics'
      call_statistics:  'Call Statistics'
      connected_agents: 'Connected Agents'
      current_calls:    'Current Calls'
      dashboard:        'Dashboard'
      help:             'Help'
      inbound_calls:    'Inbound Calls'
      my_settings:      'My Settings'
      new_agent:        'Add an Agent'
      team_chat:        'Team Chat'
      use_web_phone:    'Use the web-phone'
    calls:
      active_calls:     'Active calls'
      avg_queue_delay:  'Avg. queue delay'
      call_count:       'call count'
      call_queue_empty: 'The call queue is empty right now.'
      dispatched_calls: 'Dispatched calls'
      hide_foreign:     'Hide foreign calls'
      incoming_calls:   'Incoming calls'
      max_queue_delay:  'Max. queue delay'
      queued_calls:     'Queued calls'
      seconds:          'seconds'
      you_are_talking:  'You are talking to'
    placeholder:
      an_email_address: 'An e-mail address..'
      enter_remarks:    'Enter remarks for this call..'
      find_an_agent:    'Find an agent..'
      no_recent_messg:  'There are no recent messages in the team chat until now &mdash; be the first to write one!'
      optional_text:    'Enter optional text..'
      refresh_tickets:  "Refresh this customer's #{env.crmProvider} tickets"
      the_full_name:    'The full name..'
      the_user_id:      'The user\'s Id..'
      type_a_number:    'Type a number..'
      type_here:        'Type here..'
    errors:
      ajax_error:       'Sorry, the server returned an error message:<br />MSG'
      must_be_text:     'Must be a text..'
      number_format:    'Local numbers: 030... / Intl. numbers: 0049...'
      email_format:     'Enter a valid email address'
      extension_format: 'Enter 3 digits'
      fullname_format:  'Enter the agent\'s full name'
      password_format:  'Enter 8 or more chars.: 1 lower, 1 upper, 1 digit'
      password_match:   'Must match the first password'
      crmuser_format:   'Enter 9 digits'
      sip_secret:       '6 or more digits'
      webrtc_access:    'We could not open the sound device.<br />Please allow the browser to access it<br />in the WebRTC settings.'
