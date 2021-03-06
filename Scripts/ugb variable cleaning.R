library(sf)
library(mapview)
library(sp)

###Code from Nick Kobel email 11/25

## Tutorial where this comes from:
# https://gis.stackexchange.com/questions/288570/find-nearest-point-along-polyline-using-sf-package-in-r

# Get the UGB shapefile here: http://rlisdiscovery.oregonmetro.gov/?action=viewDetail&layerID=178
# Read in UGB, cast to multilinestring
ugb <- st_read("./DATA/ugb/ugb.shp") %>% 
  st_transform(2913) %>% 
  st_cast(., "MULTILINESTRING")

# As an example, let's see how far away City Hall is from the UGB, so get City Hall as a sf object
cityhall_coord <- data.frame(
  place=c("City Hall"),
  longitude=(-122.678904),
  latitude=(45.514858))

cityhall <- st_as_sf(cityhall_coord, coords = c("longitude", "latitude")) %>%
  st_set_crs(4326) %>%
  st_transform(2913)

# Since we use the rgeos::gNearestPoints function, we need to cast from sf object to sp object. 
#Create a separate sp object to speed up processing time when this is applied to the whole dataset
cityhall.sp <- as_Spatial(cityhall)
ugb.sp <- as_Spatial(ugb)

# Find the nearest point (this is just an FYI, not actually necessary)
nearest_point_to_ugb <- st_as_sf(
  rgeos::gNearestPoints(cityhall.sp, ugb.sp)[2,])

# View the nearest point
mapview(cityhall) + mapview(ugb) + mapview(nearest_point_to_ugb)

# Find the distance between the two points and assign it to a new variable in cityhall
## This way converts back to sf object, but it is not necessary - might cause more processing time
cityhall$dist2ugb <- as.numeric(st_distance(st_as_sf(
  rgeos::gNearestPoints(cityhall.sp, ugb.sp)[2,]), cityhall))

## This way keeps it as an sp object
cityhall$dist2ugb <- raster::pointDistance(
  rgeos::gNearestPoints(cityhall.sp, ugb.sp)[2,], cityhall.sp)

------------------------------------------------------------------------------------------------------

###Finding distance to UGB for taxlots data 
#(not sure if taxlots is the dataset we want to add it to)

# Read in UGB, cast to multilinestring
ugb <- st_read("./DATA/ugb/ugb.shp") %>% 
  st_transform(2913) %>% 
  st_cast(., "MULTILINESTRING")

# Convert to sp object (might need to st_as_sf(taxlots_pruned) first if this doesn't work)
taxlots.sp <- as_Spatial(taxlots_pruned)
ugb.sp <- as_Spatial(ugb)

# Find the distance between the two points and assign it to a new variable in cityhall
# This way converts back to sf object, but it is not necessary - might cause more processing time
taxlots_pruned$dist2ugb <- as.numeric(st_distance(st_as_sf(
  rgeos::gNearestPoints(taxlots.sp, ugb.sp)[2,]), taxlots.sf))

------------------------------------------------------------------------------------------------------

# This way keeps it as an sp object -- not working as of now!!! 
#Need to convert taxlots.sp to spatialPOINTSdataframe 
#(currently in spatialPOLYGONdataframe -- perhaps?)
taxplots_pruned$dist2ugb.sp <- raster::pointDistance(
  rgeos::gNearestPoints(taxlots.sp, ugb.sp)[2,], taxlots.sp)



