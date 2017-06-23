import flask
import subprocess

def crawl():
    print 'Starting the crawl job...'

    #cmd = "/data/sparkler/bin/sce.sh -sf /data/sce-cmd/seed_imported.txt"
    print flask.current_app.config['CMD_CRAWL']
    subprocess.call(flask.current_app.config['CMD_CRAWL'], shell=True)

    return str(0)


def exist():
    cmd = "ps -elf | grep sparkler | grep -v grep | wc -l"
    output = subprocess.check_output(cmd, shell=True)

    print output

    return str(output)


def kill():
    cmd = "ps -elf | grep sparkler | grep -v grep | awk '{print $4}' | xargs -Ipid kill -9 pid"
    output = subprocess.check_call(cmd)

    return str(output)


def int():
    cmd = "ps -elf | grep sparkler | grep -v grep | awk '{print $4}' | xargs -Ipid kill -2 pid"
    output = subprocess.check_call(cmd)

    return str(output)