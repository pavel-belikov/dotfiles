from ycm_core import CompilationDatabase
import os
import json

def FindCompilationDatabase():
    path = os.getcwd()
    patterns = ('build/compile_commands.json', '.ycm/compile_commands.json')
    for _ in range(20):
        for pattern in patterns:
            json_path = os.path.join(path, pattern)
            if os.path.exists(json_path):
                return json_path
        path = os.path.abspath(os.path.join(path, os.pardir))
    return None


def LoadCompilationDatabase(file):
    if not file:
        return None
    with open(file) as f:
        j = json.load(f)
        return set(o['file'] for o in j)


database_file = FindCompilationDatabase()
database = CompilationDatabase(os.path.dirname(database_file)) if database_file else None
database_json = LoadCompilationDatabase(database_file)


def FindFile(filename):
    if filename in database_json:
        return filename

    name, ext = os.path.splitext(filename)
    if name.endswith('-inl'):
        name = name[:-4]

    exts = ['.h', '.hpp', '.hxx', '.c', '.cc', '.cpp', '.cxx']

    for e in exts:
        if (name + e) in database_json:
            return name + e

    files = sorted([(f, os.path.commonprefix([os.path.abspath(f), os.path.abspath(filename)])) for f in database_json], key=lambda l: len(l[1]), reverse=True)
    if files:
        return files[0][0]

    return filename


def Settings(**kwargs):
    if not 'filename' in kwargs or kwargs['language'] != 'cfamily':
        return {}
    filename = kwargs['filename']
    flags = None
    if database:
        flags = database.GetCompilationInfoForFile(FindFile(filename))
        if flags:
            flags = list(flags.compiler_flags_)

    if not flags:
        flags = ['-x', 'c++', '-std=c++17', '-I' + os.getcwd()]

    includes = []
    if database:
        to_dir = os.path.dirname(database_file)
        from_dir = os.path.abspath(os.path.join(to_dir, os.pardir))
        for f in flags:
            if f.startswith('-I'):
                f = f[2:]
                if f.startswith(from_dir + '/'):
                    includes.append('-I' + to_dir + f[len(from_dir):])

    return {
        'flags': flags + includes,
        'do_cache': True
    }

