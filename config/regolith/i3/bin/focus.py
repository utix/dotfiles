#!/usr/bin/env python3
import argparse
import i3


def getIds():
    num = i3.filter(i3.get_workspaces(), focused=True)[0]['num']
    ws_nodes = i3.filter(num=num)[0]['nodes']
    ws_nodes = ws_nodes + i3.filter(num=num)[0]['floating_nodes']
    curr = i3.filter(ws_nodes, focused=True)[0]

    ids = [win['id'] for win in i3.filter(ws_nodes, nodes=[])]

    return ids, curr['id']

def focus_next():
    ids, current_id = getIds()
    next_idx = (ids.index(current_id) + 1) % len(ids)
    next_id = ids[next_idx]

    i3.focus(con_id=next_id)

def focus_prev():
    ids, current_id = getIds()
    prev_idx = (ids.index(current_id) - 1) % len(ids)
    prev_id = ids[prev_idx]

    i3.focus(con_id=prev_id)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='i3.Focus to next or previous window.')
    parser.add_argument('-p', '--previous', action='store_true')
    args = parser.parse_args()
    if args.previous:
        focus_prev()
    else:
        focus_next()
