def descarga_optimumR(usuario='pbertinat', password='Pbertinat1@', medidores=',CIR0141437451,CIR0141437454,CIR0141449346,CIR0141449576,CIR0141452066,CIR0141452067', fecha_inicio='2019-01-01', fecha_fin='2019-01-02', channel='Active Import Inc - 0'):

  import requests
  import csv
  import json
  import pandas as pd
  
  #Datos para login:
  cod='RA10PW' 
  login_data = {
      'login': '1',
      'usuario': usuario, 
      'password': password,
      'codigo': cod
  } 

  length="100000000" #cantidad de filas máxima que trae la consulta Perfil de Carga
  
  #Crea cadena para reemplazar medidor en consultas de canal y de perfil de carga
  medidor_perfil = medidores.replace(',', '&meter%5B%5D=')
  medidor_canal = medidores.replace(',', '&met%5B%5D=')
  
  with requests.Session() as s:
    #Request para login
    url="http://45.161.172.12:8092/optimum/"
    r = s.post(url, data=login_data)
    
    #Request para canales
    url="http://45.161.172.12:8092/optimum/perfilGrafico.php?getCanalesPerfil=1"+medidor_canal+"&tipoValor=1&fde="+fecha_inicio+"&fha="+fecha_fin
    r = s.get(url)
    #Carga la respuesta de la consulta de canales en json
    canales = json.loads(r.text)
    #Crea cadena canal para reemplazar en url de consulta Perfil de Carga
    for i in canales['datos']:
      if(i['descr']==channel):
        canal=i['channel']+'-'+i['id'].replace(',', '%2C')
    #Request para Perfil de Carga
    url="http://45.161.172.12:8092/optimum/perfilGrafico.php?order%5B0%5D%5Bcolumn%5D=0&order%5B0%5D%5Bdir%5D=asc&start=0&length="+length+"&loadTbl=1"+medidor_perfil+"&fde="+fecha_inicio+"&fha="+fecha_fin+"&canal%5B%5D="+canal+"&valor=1"
    #url="http://45.161.172.12:8092/optimum/perfilGrafico.php?draw=1&columns%5B0%5D%5Bdata%5D=0&columns%5B0%5D%5Bname%5D=&columns%5B0%5D%5Bsearchable%5D=true&columns%5B0%5D%5Borderable%5D=true&columns%5B0%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B0%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B1%5D%5Bdata%5D=1&columns%5B1%5D%5Bname%5D=&columns%5B1%5D%5Bsearchable%5D=true&columns%5B1%5D%5Borderable%5D=true&columns%5B1%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B1%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B2%5D%5Bdata%5D=2&columns%5B2%5D%5Bname%5D=&columns%5B2%5D%5Bsearchable%5D=true&columns%5B2%5D%5Borderable%5D=true&columns%5B2%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B2%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B3%5D%5Bdata%5D=3&columns%5B3%5D%5Bname%5D=&columns%5B3%5D%5Bsearchable%5D=true&columns%5B3%5D%5Borderable%5D=true&columns%5B3%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B3%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B4%5D%5Bdata%5D=4&columns%5B4%5D%5Bname%5D=&columns%5B4%5D%5Bsearchable%5D=true&columns%5B4%5D%5Borderable%5D=true&columns%5B4%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B4%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B5%5D%5Bdata%5D=5&columns%5B5%5D%5Bname%5D=&columns%5B5%5D%5Bsearchable%5D=true&columns%5B5%5D%5Borderable%5D=true&columns%5B5%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B5%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B6%5D%5Bdata%5D=6&columns%5B6%5D%5Bname%5D=&columns%5B6%5D%5Bsearchable%5D=true&columns%5B6%5D%5Borderable%5D=true&columns%5B6%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B6%5D%5Bsearch%5D%5Bregex%5D=false&columns%5B7%5D%5Bdata%5D=7&columns%5B7%5D%5Bname%5D=&columns%5B7%5D%5Bsearchable%5D=true&columns%5B7%5D%5Borderable%5D=true&columns%5B7%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B7%5D%5Bsearch%5D%5Bregex%5D=false&order%5B0%5D%5Bcolumn%5D=0&order%5B0%5D%5Bdir%5D=asc&start=0&length="+length+"&search%5Bvalue%5D=&search%5Bregex%5D=false&loadTbl=1"+medidor_perfil+"&fde="+fecha_inicio+"&fha="+fecha_fin+"&canal%5B%5D="+canal+"&valor=1&tipo=1&_=1589197915846"
    r = s.post(url)
    data = json.loads(r.text)
    url_logout = "http://45.161.172.12:8092/optimum/login.php?logout=1"
    s.post(url_logout)
    
  dataset = pd.DataFrame(data['data'])
  return(dataset)
