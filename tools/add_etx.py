import re
import os
import math
import io

encoding = 'gb2312'

inputPath = 'input\\'
outputPath = 'output\\'

fileNameTuple = (
    'Autonote.txt',
    'Class.txt',
    'ITEMS.TXT',
    'npcprof.txt',
    'Quests.txt',
    'Scroll.txt',
    'SKILLDES.TXT',
    'Spells.txt',
    'stats.txt'
)

lenPerLineTuple = (
    46,
    54,
    40,
    36,
    46,
    68,
    54,
    50,
    54
)

regexTargetTuple = (
    re.compile(r"(^.*?\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(r"(^.*?\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(
        r"(^.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(
        r"(^.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(r"(^.*?\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(r"(^.*?\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(
        r"(^.*?\t\"{0,1})(.*?)(\"{0,1}\t\"{0,1})(.*?)(\"{0,1}\t\"{0,1})(.*?)(\"{0,1}\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(
        r"(^.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t.*?\t\"{0,1})(.*?)(\"{0,1}\t\"{0,1})(.*?)(\"{0,1}\t\"{0,1})(.*?)(\"{0,1}\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL),
    re.compile(r"(^.*?\t\"{0,1})(.*?)(\"{0,1})(?=\t|$)", re.DOTALL)
)


def countEtx(text, lenPerLineT, situation):
    lines = re.findall(regexLine, '\n'+text)
    etxCountT = 0
    for line in lines:
        if situation == 1:  # fileName == 'npcprof.txt'
            l = len(line.encode(encoding)) + 7 * line.count('%01')
        # (fileName == 'SKILLDES.TXT' or 'Spells.txt') and (group(5) or (8) or (11))
        elif situation == 2:
            l = len(line.encode(encoding)) + 6
        else:
            l = len(line.encode(encoding))
        if l > 0:
            etxCountT += int(math.floor((l-1)/lenPerLineT))
    return etxCountT


def replFunc(match):

    if fileName == 'npcprof.txt':
        etxCount = countEtx(match.group(2), lenPerLine, 1)
    elif (fileName == 'SKILLDES.TXT') or (fileName == 'Spells.txt'):
        etxCount = countEtx(match.group(2), lenPerLine, 0) + countEtx(match.group(4), lenPerLine, 2) + \
            countEtx(match.group(6), lenPerLine, 2) + \
            countEtx(match.group(8), lenPerLine, 2)
    else:
        etxCount = countEtx(match.group(2), lenPerLine, 0)

    if etxCount > 0:
        if (fileName == 'SKILLDES.TXT') or (fileName == 'Spells.txt'):
            return match.group(1) + match.group(2) + match.group(3) + match.group(4) + match.group(5) + match.group(6) + match.group(7) + match.group(8) + unichr(3) * etxCount + match.group(9)
        else:
            return match.group(1) + match.group(2) + unichr(3) * etxCount + match.group(3)
    else:
        return match.group(0)


for number in range(0, len(fileNameTuple)):
    fileName = fileNameTuple[number]
    regexTarget = regexTargetTuple[number]
    lenPerLine = lenPerLineTuple[number]

    regexGeneral = re.compile(r"(?<=\r\n).*?(?=\r\n|$)", re.DOTALL)
    regexLine = re.compile(r"(?<=\n).*?(?=\n|$)", re.DOTALL)

    content = open(inputPath + fileName, 'rb').read()
    text = content.decode(encoding)

    items = re.findall(regexGeneral, '\r\n'+text)

    itemList = []
    # include items[0] (i.e. the first line) without processing the replacement
    itemList.append(items[0])
    for item in items[1:]:  # skip items[0] (i.e. the first line)
        itemList.append(re.sub(regexTarget, replFunc, item))

    newContent = '\r\n'.join(itemList)

    curDir = os.path.dirname(os.path.realpath('__file__'))
    if not os.path.exists(os.path.join(curDir, outputPath)):
        os.makedirs(os.path.join(curDir, outputPath))
    nf = io.open(os.path.join(curDir, outputPath, fileName),
                 'w', newline='', encoding=encoding)
    nf.write(newContent)
    nf.close()
