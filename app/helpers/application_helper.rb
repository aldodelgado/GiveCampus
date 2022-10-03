module ApplicationHelper
  def enum_for_collection(klass, enum, only: [], except: [], prefix: nil)
    values = klass.send(enum.to_s.pluralize).keys
    only = Array.wrap(only)
    except = Array.wrap(except)

    if only.any?
      only = only.map(&:to_s)
      values = values & only
    end

    if except.any?
      except = except.map(&:to_s)
      values = values - except
    end

    values.map { |val| ["#{prefix}#{get_i18n(klass, enum, val)}", val] }.unshift(['Select your option', "", { hidden: true }])
  end

  def enum_text(model, enum)
    get_i18n(model.class, enum, model.send(enum))
  end

  private

  def get_i18n(klass, enum, value)
    if value
      klass_key = klass.to_s.underscore.tr('/', '.')
      I18n.t("activerecord.enums.#{klass_key}.#{enum}.#{value}", default: "#{value.titleize}")
    else
      ''
    end
  end
end
