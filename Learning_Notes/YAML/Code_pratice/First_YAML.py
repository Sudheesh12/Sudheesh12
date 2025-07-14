import yaml

with open( file ='./First.yaml', mode = 'r') as file:
    try:
        print(yaml.safe_load(file))
    except yaml.YAMLError as exc:
        print(exc)

