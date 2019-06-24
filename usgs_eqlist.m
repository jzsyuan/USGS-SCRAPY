function [data,describe] = usgs_eqlist(syr,smo,sda,eyr,emo,eda,varargin)
% Input arguments
%
% input                 type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% syr                   integer     none        start time of year
% smo                   integer     none        start time of month
% sda                   integer     none        start time of day
% eyr                   integer     none        end time of year
% emo                   integer     none        end time of month
% eda                   integer     none        end time of day
%
% Optional Input arguments
%
% Location - Rectangle
% parameter             type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% minlat                float       -90         Limit to events with a latitude larger than the specified minimum. NOTE: min values must be less than max values.
% maxlat                float       90          Limit to events with a latitude smaller than the specified maximum. NOTE: min values must be less than max values.
% minlong               float       -180        Limit to events with a longitude larger than the specified minimum. NOTE: rectangles may cross the date line by using a minlongitude < -180 or maxlongitude > 180. NOTE: min values must be less than max values.
% maxlong               float       180         Limit to events with a longitude smaller than the specified maximum. NOTE: rectangles may cross the date line by using a minlongitude < -180 or maxlongitude > 180. NOTE: min values must be less than max values.
% -getrect                                      Specify the Location in rectangle on a global map.
%
% Location - Circle
% parameter             type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% latitude              float       null        Specify the latitude to be used for a radius search.
% longitude             float       null        Specify the longitude to be used for a radius search.
% mrad                  float       180         Limit to events within the specified maximum number of degrees from the geographic point defined by the latitude and longitude parameters. NOTE: This option is mutually exclusive with maxradiuskm and specifying both will result in an error.
% mradkm                float       20001.6     Limit to events within the specified maximum number of kilometers from the geographic point defined by the latitude and longitude parameters. NOTE: This option is mutually exclusive with maxradius and specifying both will result in an error.
%
% Magnitude
% parameter             type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% minmag                float       2.5         Limit to events with a magnitude larger than the specified minimum.
% maxmag                float       null        Limit to events with a magnitude smaller than the specified maximum.
%
% Depth
% parameter             type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% mindepth              float       -100        Limit to events with depth more than the specified minimum.
% maxdepth              float       1000        Limit to events with depth less than the specified maximum.
%
% 
% Others : NOTE!!! Following argumets please enter with quotes (String)
% parameter             type        default     description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% catalog               String      null        Limit to events from a specified catalog. Use the Catalogs Method to find available catalogs. NOTE: when catalog and contributor are omitted, the most preferred information from any catalog or contributor for the event is returned.
% contributor           String      null        Limit to events contributed by a specified contributor. Use the Contributors Method to find available contributors. NOTE: when catalog and contributor are omitted, the most preferred information from any catalog or contributor for the event is returned.
% eventid               String      null        Select a specific event by ID; event identifiers are data center specific. NOTE: Selecting a specific event implies includeallorigins, includeallmagnitudes, and, additionally, associated moment tensor and focal-mechanisms are included.
% includeallmagnitudes	Boolean     false       Specify if all magnitudes for the event should be included, default is data center dependent but is suggested to be the preferred magnitude only. NOTE: because magnitudes and origins are strongly associated, this parameter is interchangeable with includeallmagnitudes
% includeallorigins     Boolean     false       Specify if all origins for the event should be included, default is data center dependent but is suggested to be the preferred origin only. NOTE: because magnitudes and origins are strongly associated, this parameter is interchangable with includeallmagnitudes
% includearrivals       Boolean     false       Specify if phase arrivals should be included. NOTE: NOT CURRENTLY IMPLEMENTED
% includedeleted        Boolean     false       Specify if deleted products should be incuded. NOTE: Only works when specifying eventid parameter.
% includesuperseded     Boolean     false       Specify if superseded products should be included. This also includes all deleted products, and is mutually exclusive to the includedeleted parameter. NOTE: Only works when specifying eventid parameter.
% limit                 Integer     null        Limit the results to the specified number of events. NOTE: The service limits queries to 20000, and any that exceed this limit will generate a HTTP response code ?00 Bad Request?   
%                       [1,20000]
% offset                Integer     1           Return results starting at the event count specified, starting at 1.
%                       [1,?]	
% orderby               String      time        Order the results. The allowed values are:
%                                               orderby=time
%                                               order by origin descending time
%                                               orderby=time-asc
%                                               order by origin ascending time
%                                               orderby=magnitude
%                                               order by descending magnitude
%                                               orderby=magnitude-asc
%                                               order by ascending magnitude
% alertlevel            String      null        Limit to events with a specific PAGER alert level. The allowed values are:
%                                               alertlevel=green
%                                               Limit to events with PAGER alert level "green".
%                                               alertlevel=yellow
%                                               Limit to events with PAGER alert level "yellow".
%                                               alertlevel=orange
%                                               Limit to events with PAGER alert level "orange".
%                                               alertlevel=red
%                                               Limit to events with PAGER alert level "red".
% callback              String      null        Convert GeoJSON output to a JSONP response using this callback. Mime-type is “text/javascript? NOTE: Must be used with format=geojson
% eventtype             String      null        Limit to events of a specific type. NOTE: “earthquake?will filter non-earthquake events.
% jsonerror             Boolean     false       Request JSON(P) formatted output even on API error results. NOTE: Must be used with format=geojson
% kmlanimated           Boolean     false       Whether to include timestamp in generated kml, for google earth animation support. NOTE: Must be used with format=kml
% kmlcolorby            String      age         How earthquakes are colored. Accepted values are:
%                                               kmlcolorby=age
%                                               Color events in KML by age.
%                                               kmlcolorby=depth
%                                               Color events in KML by depth.
%                                               NOTE: Must be used with format=kml
% maxcdi                Decimal     null        Maximum value for Maximum Community Determined Intensity reported by DYFI.
%                       [0,12]
% maxgap                Decimal     null        Limit to events with no more than this azimuthal gap.
%                       [0,360]
%                       degree
% maxmmi                Decimal     null        Maximum value for Maximum Modified Mercalli Intensity reported by ShakeMap.
%                       [0,12]
% maxsig                Integer     null        Limit to events with no more than this significance.
% mincdi                Decimal     null        Minimum value for Maximum Community Determined Intensity reported by DYFI.
% minfelt               Integer     null        Limit to events with this many DYFI responses.
%                       [0,?]
% mingap                Decimal     null        Limit to events with no less than this azimuthal gap.
%                       [0,360]
%                       degree
% minsig                Integer     null        Limit to events with no less than this significance.
% nodata                Integer     204         Define the error code that will be returned when no data is found.
%                       (204|404)
% producttype           String      null        Limit to events that have this type of product associated. Example producttypes:
%                                               moment-tensor
%                                               focal-mechanism
%                                               shakemap
%                                               losspager
%                                               dyfi
% productcode           String      null        Return the event that is associated with the productcode. The event will be returned even if the productcode is not the preferred code for the event. Example productcodes:
%                                               nn00458749
%                                               at00ndf1fr
% reviewstatus          String      all         Limit to events with a specific review status. The different review statuses are:
%                                               reviewstatus=automatic
%                                               Limit to events with review status "automatic".
%                                               reviewstatus=reviewed
%                                               Limit to events with review status "reviewed".
%
%===================================================================================================================================================================================================================================
%
% Output variables including two matrixes
% Variable name         type        description
%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% data                  double      Year, Month, Day, hr, min, sec, Latitude, Longitude, Depth/km, Magnitude
% describe              cell        EventID, Author, Catalog, Contributor, ContributorID, MagType, MagAuthor, EventLocationName



% check if input arguments enough, at lest 6, including start year, start
% month, start day, end year, end month and end day
minArgs = 6;
maxArgs = 100;
narginchk(minArgs,maxArgs)

sstr = datestr(datenum(syr,smo,sda),'yyyy-mm-dd');
estr = datestr(datenum(eyr,emo,eda),'yyyy-mm-dd');

surl = ['https://earthquake.usgs.gov/fdsnws/event/1/query?format=text&minmag=2.5&starttime=',sstr,'&endtime=',estr];

nopt = nargin-6; % number of optional arguments

i = 1;
while i <= nopt    
    if strcmp(varargin{i},'-getrect')
        f = figure;
        load coast
        plot(long,lat,'b')
        hold on
        plot(long+360,lat,'k')
        plot(long-360,lat,'k')
        xlabel('Longitude','FontSize',15)
        ylabel('Latitude','FontSize',15)
        axis image
        axis([-270 270 -90 90])
        grid on
        set(gca,'YTick',-90:30:90,'XTick',-270:60:270)
        drawnow
        rect = getrect;
        close(f)
        surl = [surl,'&minlatitude=',num2str(rect(2))];
        surl = [surl,'&maxlatitude=',num2str(rect(2)+rect(4))];
        surl = [surl,'&minlongitude=',num2str(rect(1))];
        surl = [surl,'&maxlongitude=',num2str(rect(1)+rect(3))];
        
        i = i+1;
    else
        if (nopt<i+1)
            error(['Error in ',varargin{i+1-1},' argument'])
        end
        
        switch varargin{i}
            case 'maxlat'
                surl = [surl,'&maxlatitude=',num2str(varargin{i+1})];
            case 'minlat'
                surl = [surl,'&minlatitude=',num2str(varargin{i+1})];
            case 'maxlong'
                surl = [surl,'&maxlongitude=',num2str(varargin{i+1})];
            case 'minlong'
                surl = [surl,'&minlongitude=',num2str(varargin{i+1})];
            case 'latitude'
                surl = [surl,'&latitude=',num2str(varargin{i+1})];
            case 'longitude'
                surl = [surl,'&longitude=',num2str(varargin{i+1})];
            case 'mrad'
                surl = [surl,'&maxradius=',num2str(varargin{i+1})];
            case 'mradkm'
                surl = [surl,'&maxradiuskm=',num2str(varargin{i+1})];
            case 'minmag'
                surl = [surl,'&minmagnitude=',num2str(varargin{i+1})];
            case 'maxmag'
                surl = [surl,'&maxmagnitude=',num2str(varargin{i+1})];
            case 'mindepth'
                surl = [surl,'&mindepth=',num2str(varargin{i+1})];
            case 'maxdepth'
                surl = [surl,'&maxdepth=',num2str(varargin{i+1})];
            otherwise
                surl = [surl,'&',varargin{i},'=',varargin{i+1}];
        end
        i = i+2;
    end
end
% surl

try
    delete 'usgs_eqlist_temporary.txt';
    urlwrite(surl,'usgs_eqlist_temporary.txt');
    source_data=importdata('usgs_eqlist_temporary.txt');
catch
    error('Error in argument or downloading URL.')
end

for i = 2:length(source_data)
    temp = strsplit(source_data{i},'|');
    
    data(i-1,1:6) = datevec(temp{2},'yyyy-mm-ddTHH:MM:SS.FFF');
    
    k = 6;
    for j = [3,4,5,11]
        k = k+1;
        data(i-1,k) = str2num(temp{j});
    end
    
    k = 0;
    for j = [1,6,7,8,9,10,12,13]
        k = k+1;
        describe{i-1,k} = temp{j};
    end
end
end




