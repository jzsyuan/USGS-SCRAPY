clear
clc

% example 1: usgs_eqlist(syear,smonth,sday,eyear,emonth,eday)

syear = 2000;
smonth = 1;
sday = 1;

eyear = 2000;
emonth = 2;
eday = 1;

[data1, describe1] = usgs_eqlist(syear,smonth,sday,eyear,emonth,eday);

% example 2: usgs_eqlist(syear,smonth,sday,eyear,emonth,eday,'Optional',Value)

eyear = 2005;
emonth = 1;
eday = 1;

mmag = 5;
mlong = 120;
Mlong = 123;
mlat = 20;
Mlat = 25;

[data2, describe2] = usgs_eqlist(syear,smonth,sday,eyear,emonth,eday,'minmag',mmag,'minlong',mlong,'maxlong',Mlong,'minlat',mlat,'maxlat',Mlat);

% example 3: usgs_eqlist(syear,smonth,sday,eyear,emonth,eday,'Optional',Value,'Others','Value')

[data3, describe3] = usgs_eqlist(syear,smonth,sday,eyear,emonth,eday,'minmag',mmag,'minlong',mlong,'maxlong',Mlong,'minlat',mlat,'maxlat',Mlat,'limit','30','orderby','time-asc');

% example 4: 

eyear = 2005;
emonth = 1;
eday = 1;

[data4, describe4] = usgs_eqlist(syear,smonth,sday,eyear,emonth,eday,'-getrect');

