local GM = GM
local const = GM.constants
local Color = Color

--
-- Constants Table
--

-- Colors for use in HUD's etc
const.colors = {
	white = Color(255, 255, 255, 255),
	yellow = Color(250, 250, 100),
	green = Color(100, 255, 100, 255),
	orange = Color(255, 127, 36, 255),
	red = Color(205, 51, 51, 255)
}

-- Material properties, used for temperature calcs and player calcs
-- Thanks to Dr D.S.Gill for help regarding this process.

-- http://www.roymech.co.uk/Related/Thermos/Thermos_HeatTransfer.html
-- used in the formula to calculate temperature changes (Nylon 6)
const.SUIT_THERMAL_CONDUCTIVITY = 0.91 -- used the emissivity of plastic, as this is for radiation

const.BOLTZMANN = 0.00000005673 -- Stefan Boltzmann constant = 5.673 x10^-8 W m^-2 K^-4
const.EMISSIVITY = {
	skin = 0.98,
	plastic = 0.91,
	aluminium = 0.05
}

const.SPECIFIC_HEAT_CAPACITY = {  -- In J/Kg please
	skin = 3470, -- J/Kg
	plastic = 1.67*1000, --J/Kg
	aluminium = 0.91*1000, -- Get the value into Joules/Kg
}

const.PLY_MASS = 100 -- In Kg please

const.BODY_SURFACE_AREA = 1.9 -- For men the average BSA is 1.9 m^2