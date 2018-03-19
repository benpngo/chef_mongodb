def mongod_conf(setting, counter, lines = [])
  setting.each do |value, config|
    if config.is_a?(Hash)
      lines << "#{" " * (counter * 2 )}#{value}:"
			lines << mongod_conf(config, counter + 1 )
    else
      lines << "#{" " * (counter * 2 )}#{value}: #{config}"
    end
  end
  return lines.flatten
end
