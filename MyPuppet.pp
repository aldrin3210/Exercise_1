class mypuppet{
    #install packages
    $mypackage = ['vim','curl','git']
    Package { $mypackage: ensure => 'installed' }

    #create a user
    user {
        'monitor':
        ensure => 'present',
        home => '/home/monitor',
        password => '!!',
        shell => '/bin/bash',        
    }

    #create directory
    file{ '/home/monitor/scripts':
        ensure => 'directory',
        owner => 'root',
    }

    #download file from git
    exec {'download_checker':
        command => "/usr/bin/wget -q https://raw.githubusercontent.com/aldrin3210/Exercise_1/master/memnory_checker.sh -o /home/monitor/scripts",
        creates => "/home/monitor/scripts",
    }

    file { '/home/monitor/scripts':
        mode => 0755,
        require => Exec["download_checker"],
    }

    #create symlink
    file { '/home/monitor/src':
        ensure => 'directory',
        owner => 'root',
    }

    file {'/home/monitor/scripts/memory_checker.sh':
        ensure => 'link',
        target => '/home/monitor/src',
    }

    #crontab
    cron {'Check_Memory':
        command => '/home/monitor/scripts/memory_checker.sh',
        user => 'root',
        hour => 0,
        minute = 10,
    }

}