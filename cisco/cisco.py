#!/usr/bin/env python

import pexpect
import random
from datetime import *
import smtplib
from email.mime.text import MIMEText

def getnow():
	'''
	Get now time.
	'''
	dt = datetime.now()
	return dt.strftime('%Y-%m-%d-%H:%M:%S')

def login(switchip, password, firewallip):
	'''
	login to cisco_hx3750,then login to cisco_asa.
	'''

	t = pexpect.spawn('/usr/bin/telnet %s' % switchip)
	t.sendline(password)

	t.expect('>')
	t.sendline(firewallip)

	t.expect('Password:')
	t.sendline(password)

	t.expect('>')
	t.sendline('en')

	t.expect('Password:')
	t.sendline(password)

	i = t.expect('#')
	if i == 0:
		return t, 'Login and enable privilege mode on Cisco ASA success!'
	else:
		return False, 'Login and enable privilege mode on Cisco ASA failed......'

def backup(t, tftp, firewallip):
	'''
	Backup cisco asa running-config to tftp server before change interface e0/0.
	'''
	t.sendline('copy running-config tftp')
	t.expect('.*filename.*')

	t.sendline('running-config')
	t.expect('.*remote.*')

	t.sendline(tftp)
	t.expect('.*filename.*')

	t.sendline('asa_running_config_%s.cfg' % getnow())

	i = t.expect('#')
	if i == 0:
		return t, 'Backup Cisco ASA running-config to tftp server success!'
	else:
		return False, 'Backup Cisco ASA running-config failed......'


def chg_e0(t):
	'''
	Change interface e0/0.
	'''

	t.sendline('sh interface ethernet 0/0 | include 203')
	t.expect('sh interface ethernet 0/0 | include 203')
	t.expect('#')

#	e0_old = t.before[27:41]
	if t.before[41] == ',':
		e0_old = t.before[27:41]
	else:
		e0_old = t.before[27:40]
	e0.remove(e0_old)
	e0_new = str(random.choice(e0))

	t.sendline('conf t')
	t.expect('#')

	t.sendline('int e0/0')
	t.expect('#')

	t.sendline('no ip address ' + e0_old)
	t.expect('#')

	t.sendline('ip address ' + e0_new + ' 255.255.255.0')

	i = t.expect('#')
	if i == 0:
		return True, 'Change E0/0 ip address success! old ip=%s,new ip=%s' % (e0_old, e0_new)
	else:
		return False, 'Change E0/0 ip address failed......Check cisco asa immediately !!!'

	t.close()

def mail():
	'''
	Send mail when change cisco asa e0/0 failed.
	'''
	mail_server = 'smtp.gmail.com'
	mail_server_port = 587

	sender = ''
	sender_pwd = ''
	receiver = ''

	message = """Cisco ASA E0/0 Ipaddress error,please check it immediately!!!
	"""

	msg = MIMEText(message)
	msg['Subject'] = 'Cisco ASA E0/0 Ipaddress Error'
	msg['From'] = sender
	msg['To'] = receiver

	sm = smtplib.SMTP(mail_server, mail_server_port)
	sm.ehlo
	sm.starttls()
	sm.login(sender, sender_pwd)
	sm.sendmail(sender, receiver, msg.as_string())
	sm.quit()

if __name__ == '__main__':

	TIMEOUT = 1
	switchip = ''
	firewallip = ''
	e0 = ['xxx.xxx.xxx.xxx', 'xxx.xxx.xxx.xxx', 'xxx.xxx.xxx.xxx',]
	switch = 'HX3750'
	firewall = 'ciscoasa'
	password = ''
	tftp = ''

	f = open('/data/logs/cisco.txt', 'a')

	(ret, msg) = login(switchip, password, firewallip)

	if ret == False:
		print >> f, getnow(), msg
		sys.exit(msg)
	print msg
	print >> f, getnow(), msg

	telnet = ret

	(ret, msg) = backup(telnet, tftp, firewallip)

	if ret == False:
		print >> f, getnow(), msg
	print msg
	print >> f, getnow(), msg

	(ret, msg) = chg_e0(telnet)

	if ret == False:
		mail()
		print >> f, '%s %s\n\n' % (getnow(), msg)
		sys.exit(msg)
	print msg
	print >> f, '%s %s\n\n' % (getnow(), msg)
