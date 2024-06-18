def select_shim(measure:, shim:, limit_min:, limit_max:, target: nil, increment: 0.5)
  # 0.27
  target_value = target || (limit_min + (limit_max - limit_min) / 2)
  # check if we need to add or remove thickens from current shim
  thickness_modifier = measure > target_value ? -1 : 1
  # -0.05
  delta  = (measure - target_value).round(2) * thickness_modifier

  # 170 select ideal shim size
  ideal_shim_size = shim + (delta * 100)

  # 170 select existing shim size based on available increment
  increment_delta = (1 / increment)
  selected_shim = (((ideal_shim_size / 10) * increment_delta).round / increment_delta) * 10

  # 0.27 calculate new clearence
  clearance_change = ((shim - selected_shim) / 100) * thickness_modifier

  {selected_shim: selected_shim, target_clearance: target_value, clearance: (measure + clearance_change).round(2)}
end

# example
select_shim(measure: 0.23, shim: 185, limit_min: 0.24, limit_max: 0.3, target: 0.27, increment: 0.5)
select_shim(measure: 0.23, shim: 185, limit_min: 0.24, limit_max: 0.3, target: 0.27, increment: 0.25)
