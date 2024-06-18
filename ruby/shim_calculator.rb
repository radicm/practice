# Write shim calculator algorithm that selects new shim closest to targeted value by
# taking into account the difference between the specified clearance and the measured clearance.
# Shim clearance can have min and max value by default target should be in the middle value (0.23..0.27 -> 0.25) or it can be passed as arg.
# Shim comes in fixed increment sizes for example 0.25, 0.5, 0.75...
#
# Example
# measure = 0.23
# target = 0.27
# shim = 1.85
# increment = 0.5
#
# (0.27 - 0.23) = 0.04
# 1.85 + 0.4
# 1.89 nearest value 1.9
# closest new clearance 0.28
#
# Method should accepts these params
# measure -> float val > 0
# target -> float val > 0
# shim -> int val > 0
# limit_min -> float val > 0
# limit_max -> float val > 0
# increment -> float val > 0
#
# and return result
# {:selected_shim=>1.75, :target_clearance=>0.27, :clearance=>0.27}

#
def select_shim(measure:, shim:, limit_min:, limit_max:, target: nil, increment: 0.25)
  # 0.27
  target_value = target || (limit_min + (limit_max - limit_min) / 2)
  # check if we need to add or remove thickens from current shim
  thickness_modifier = measure > target_value ? -1 : 1
  # -0.05
  delta  = (measure - target_value).round(2) * thickness_modifier

  # 170 select ideal shim size
  ideal_shim_size = shim + delta

  # 170 select existing shim size based on available increment
  increment_delta = (1 / increment)

  selected_shim = (((ideal_shim_size * 10) * increment_delta).round / increment_delta) / 10

  # 0.27 calculate new clearence
  clearance_change = (shim - selected_shim).round(2) * thickness_modifier

  {selected_shim: selected_shim, target_clearance: target_value, clearance: (measure + clearance_change).round(2)}
end

# example
select_shim(measure: 0.23, shim: 1.85, limit_min: 0.24, limit_max: 0.3, target: 0.27, increment: 0.5)
select_shim(measure: 0.23, shim: 1.85, limit_min: 0.24, limit_max: 0.3, target: 0.27, increment: 0.25)
