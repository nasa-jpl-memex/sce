import flask
import subprocess

def crawl():
    seed = getattr(flask.current_app, 'seed', None)
    if seed is None:
        print 'No seed file has been uploaded!'
        return str(-1)

    print 'Starting the crawl job...'

    cmd = '/data/sparkler/bin/sce.sh -sf /data/sce-cmd/webui/' + seed + ' &'
    subprocess.call(cmd, shell=True)

    return str(0)


def exist():
    cmd = "ps -elf | grep sparkler | grep -v grep | wc -l"
    output = subprocess.check_output(cmd, shell=True)

    return str(output)


def kill():
    cmd = "ps -elf | grep sparkler | grep -v grep | awk '{print $4}' | xargs -Ipid kill -9 pid"
    output = subprocess.check_call(cmd, shell=True)

    return str(output)


def int():
    cmd = "ps -elf | grep sce.sh | grep -v grep | awk '{print $4}' | xargs -Ipid kill -9 pid"
    output = subprocess.check_call(cmd, shell=True)

    return str(output)