#!/usr/bin/python
"""
    This python script work as an ansible module.
    It writes an inventory file based on the terraform output.
    This module is very specific for this playbook.
    Probably it will not work in other playbook without changes.
"""

__author__ = "Dyego Eugenio"
__copyright__ = "Copyleft with your own risk"
__credits__ = ["Dyego Eugenio"]
__license__ = "GPL"
__version__ = "1.0.0"
__maintainer__ = "Dyego Eugenio"
__email__ = "dyegoe@gmail.com"
__status__ = "Production"


DOCUMENTATION = '''
---
module: inventory_from_terraform
short_description: Write inventory file from terraform output
author: Dyego Eugenio
email: dyegoe@gmail.com
'''

EXAMPLES = '''
- name: "Write inventory from terraform"
  inventory_from_terraform:
    outputs: "{{ terraform_output['outputs'] }}"
    inventory_file: "{{ inventory_dir }}/deploy_inventory.cfg"
        
'''

from ansible.module_utils.basic import AnsibleModule
import time, os.path
from traceback import format_exc


fields = {
    "outputs": {"required": True, "type": "dict"},
    "inventory_file": {"required": True, "type": "str"}
}
module = AnsibleModule(argument_spec=fields)
outputs = module.params['outputs']
inventory_file = module.params['inventory_file']

config = list()
config.append('[all:children]')
config.append('app')
config.append('[app:vars]')
config.append('ansible_ssh_user=admin')
config.append('ansible_ssh_private_key_file=files/id_rsa')
config.append('ansible_become=yes')
config.append('aws_iam_access_key={}'.format(outputs['aws_iam_access_key_asg_user_id']['value']))
config.append('aws_iam_secret_access_key={}'.format(outputs['aws_iam_access_key_asg_user_secret']['value']))
config.append('db_host={}'.format(outputs['aws_db_instance_main_endpoint']['value'][0]))
config.append('db_name={}'.format(outputs['aws_db_instance_db_name']['value']))
config.append('db_user={}'.format(outputs['aws_db_instance_db_user']['value']))
config.append('db_password={}'.format(outputs['aws_db_instance_db_password']['value']))
config.append('[app]')

for i in range(len(outputs['aws_instance_app_public_ip']['value'])):
    config.append('{} private_ip={}'.format(
        outputs['aws_instance_app_public_ip']['value'][i],
        outputs['aws_instance_app_private_ip']['value'][i]
    ))

with open(inventory_file, 'w+') as f:
    for line in config:
        f.write('{}\n'.format(line))

module.exit_json(changed=False, meta=None)