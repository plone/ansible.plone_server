plone_server
============

This Ansible role provisions a [Plone](https://plone.org) server with options to control client count and memory profile. It uses either a built-in buildout.cfg or one picked up via git.

This role takes care of:

- Installing the required OS (development-) packages;
- Creating users and groups for running buildout and daemons;
- Downloading a buildout-cache tarball and checking out your buildout if needed;
- Building the ZEO cluster;
- Optional: setting up `supervisor` for process management and autostart;
- Optional: installing cron-jobs for packing the database and backup.

If you'd like to use this role as part of a full-stack configuration kit, see the [Plone Ansible Playbook](https://github.com/plone/ansible-playbook).

Requirements
------------

Since this role creates and uses users and groups, it must be run as part of a playbook that sets sudo to "yes".

Currently only working with Debian/Ubuntu environments. Please put in a pull request if you can help get it going in an RPM environment.


If you need to log in
---------------------

You should not need to. But if you do, you should know:

1) The Plone zeoserver and zeoclient processes should be run under the plone_daemon login; they will normally be controlled via supervisor;

2) Run buildout as plone_buildout.



Role Variables
--------------

### plone_instance_name

    plone_instance_name: frodos_site

Sets the name that discriminates this install from others that use the same paths.

Defaults to `zeoserver`

### plone_target_path

    plone_target_path: /opt/plone

Sets the Plone installation directory.

Defaults to `/usr/local/plone-{{ plone_major_version }}`

Your install's buildout directory will be {{ plone_target_path }}/{{ plone_instance_name }}.

### plone_var_path

    plone_var_path: /var/plone_var

Sets the Plone installation directory.

Defaults to `/var/local/plone-{{ plone_major_version }}`

Your install's var directory will be {{ plone_var_path }}/{{ plone_instance_name }}.

#### plone_backup_path

    plone_backup_path: /mnt/backup/plone

Where do you want to put your backups? The destination must be writable by the `plone_daemon` user. Subdirectories are created for blob and filestorage backups.

Defaults to your instance's var directory.

Your install's backup directory will be {{ plone_backup_path }}/{{ plone_instance_name }}.

### plone_buildout_git_repo

    buildout_git_repo: https://github.com/plone/plone.com.ansible.git
    buildout_git_version: master

`buildout_git_repo` defaults to none (uses built-in buildout).

`buildout_git_version` is the tag or branch. Defaults to `master`.

> If you use your own buildout from a repository, you still need to specify your client count so that the playbook can 1) set up the supervisor specifications to start/stop and monitor clients, and 2) set up the load balancer.
>
> Client part names must follow the pattern `client#` where # is a number (1,2,3 ...). Client ports must be numbered sequentially beginning with 8081 or the value you set for plone_client_base_port. The zeoserver part must be named `zeoserver` and be at 8100 or the value you set for plone_zeo_port.
>
> If you use your own buildout, all Plone settings except `plone_client_count`, `plone_client_base_port`, and `plone_client_max_memory` are ignored.

### plone_major_version

    plone_major_version: 4.3

### plone_version

    plone_version: 4.3.3

Which Plone version do you wish to install? This defaults to the current stable version at the time you copy or clone the playbook.

### plone_initial_password

    plone_initial_password: alnv%r(ybs83nt

Initial password of the Zope `admin` user. The initial password is used when the database is first created. Don't forget to change it.

Defaults to "" -- which will cause the role to halt.


### plone_client_count

    plone_client_count: 5

How many ZEO clients do you want to run?

Defaults to `2`

> The provided buildout always creates an extra client `client_reserve` that is not hooked into supervisor or the load balancer. Use it for debugging, run scripts and quick testing.


### plone_zodb_cache_size

    plone_zodb_cache_size: 30000

How many objects do you wish to keep in the ZODB cache.

Defaults to `30000`

> The default configuration is *very* conservative to allow Plone to run in a minimal memory server. You will want to increase this is you have more than minimal memory.


### plone_zserver_threads

    plone_zserver_threads: 2

How many threads should run per server?

Defaults to `1`


### plone_client_max_memory

    plone_client_max_memory: 800MB

A size (suffix-multiplied using “KB”, “MB” or “GB”) that should be considered “too much”. If any Zope/Plone process exceeds this maximum, it will be restarted. Set to `0` for no memory monitoring.

Defaults to `0` (turned off)

> This setting is used in configuration of the `memmon` monitor in supervisor: [superlance](http://superlance.readthedocs.org/en/latest) plugin.


### plone_additional_eggs

    plone_additional_eggs:
        - Products.PloneFormGen
        - collective.cover
        - webcourtier.dropdownmenus

List additional Python packages (beyond Plone and the Python Imaging Library) that you want available in the Python package environment.

The default list is empty.

> Plone hotfixes are typically added as additional eggs.


### plone_sources

    plone_sources =
      -  "my.package = svn http://example.com/svn/my.package/trunk update=true"
      -  "some.other.package = git git://example.com/git/some.other.package.git"

Source specifications, a list of strings in [mr.developer](https://pypi.python.org/pypi/mr.developer) format. If you specify plone_sources, the mr.developer extension will be used with auto-checkout set to "*".

### plone_extension_profiles

    plone_extension_profiles:
        - jarn.jsi18n:default

List additional Plone profiles which should be activated in the new Plone site.  These are only activated if the plone_create_site variable is set.

### plone_zcml_slugs

    plone_zcml_slugs:
        - plone.reload

List additional ZCML slugs that may be required by older packages that don't implement auto-discovery. The default list is empty. This is rarely needed.


### plone_additional_versions

    plone_additional_versions:
      - "Products.PloneFormGen = 1.7.16"
      - "Products.PythonField = 1.1.3"
      - "Products.TALESField = 1.1.3"

The version pins you specify here will be added to the `[versions]` section of your buildout. The default list is empty.


### plone_zeo_port

    plone_zeo_port: 6100

The port number for the Zope database server. Defaults to `8100`.


### plone_client_base_port

    plone_client_base_port: 6080

The port number for your first Zope client. Subsequent client ports will be added in increments of 1. Defaults to `8081`.

### plone_environment_vars

    plone_environment_vars:
        - "TZ US/Eastern"
        - "zope_i18n_allowed_languages en"

A list of environment variables you wish to set for running Plone instances.

Defaults to:

    - "PYTHON_EGG_CACHE ${buildout:directory}/var/.python-eggs"


### plone_client_extras

    plone_client_extras: |
        z2-log-level = error

Extra text to add to all the client buildout parts.


### plone_client1_extras

    plone_client1_extras: |
        webdav-address = 9080
        ftp-address = 8021

Extra text to add to only the first client buildout part.


### plone_autorun_buildout

    plone_autorun_buildout: (yes|no)

Do you wish to automatically run buildout if any of the Plone settings change? Defaults to `yes`.


### plone_buildout_cache_url

    plone_buildout_cache_url: http://dist.plone.org/4.3.4/buildout-cache.tar.bz2

The URL of a buildout egg cache. Defaults to the one for the current stable version of Plone.


### plone_buildout_cache_file

    plone_buildout_cache_file: /home/steve/buildout-cache.tar.bz2

The full local (host) filepath of a buildout egg cache. Defaults to none. Should not be used at the same time as plone_buildout_cache_url.


### Cron jobs

#### plone_pack_at

    plone_pack_at:
      minute: 30
      hour: 1
      weekday: 7

When do you wish to run the ZEO pack operation? Specify minute, hour and weekday specifications for a valid *cron* time. See `CRONTAB(5)`. Defaults to 1:30 Sunday morning. Set to `no` to avoid creation of a cron job.


#### plone_keep_days

    plone_keep_days: 3

How many days of undo information do you wish to keep when you pack the database. Defaults to `3`.


#### plone_backup_at

    plone_backup_at:
      minute: 30
      hour: 2
      weekday: "*"

When do you wish to run the backup operation?  Specify minute, hour and weekday specifications for a valid *cron* time. See `CRONTAB(5)`. Defaults to 2:30 every morning.  Set to `no` to avoid creation of a cron job.


#### plone_keep_backups

    plone_keep_backups: 3

How many generations of full backups do you wish to keep? Defaults to `2`.

> Daily backups are typically partial: they cover the differences between the current state and the state at the last full backup. However backups after a pack operation are complete (full) backups -- not difference operations. Thus, keeping two full backups means that you have backups for `plone_keep_backups * days_between_packs` days. See the [collective.recipe.backup documentation](https://pypi.python.org/pypi/collective.recipe.backup).


#### plone_keep_blob_days

    plone_keep_blob_days: 21

How many days of blob backups do you wish to keep? This is typically set to `keep_backups * days_between_packs` days. Default is `14`.


### Supervisor Control

#### plone_use_supervisor

    plone_use_supervisor: no

When set to `yes` (the default), the role will set up [supervisor](http://supervisord.org/) to start, stop and control the ZEO server and all the clients except the reserved client.


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: all
      sudo: yes
      gather_facts: no

      pre_tasks:

        - name: Update host
          apt: upgrade=dist update_cache=yes

      roles:

        - role: plone.plone_server
          plone_initial_password: super_secret

License
-------

GPLv2

Author Information
------------------

Created by Steve McMahon. Maintained by the Plone Installer Team as part of the [Plone](https://plone.org) project.
