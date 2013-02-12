module Eva

  class EvaObject
  end

  module Space

    def namespace(name, methods={})
      mod = gen_const(name, Module.new)
      mod.extend mod
      mod.extend ClassMethods
      methods.each { |name, block| gen_methods(mod, name, block) }
      mod
    end

    def objectspace(name, methods={})
      if Hash === name
        (name, superclass), *methods = *name.to_a
      else
        superclass = EvaObject
      end

      klass = gen_const(name, Class.new(superclass))
      methods.each { |name, block| gen_methods(klass, name, block) }
      klass
    end

    module ClassMethods
      def included(base)
        base.extend(base) if base.class == Module
        super
      end
    end

    private
    def gen_methods(obj, name, block)
      name = name.to_s

      case name
      when 'attr'
        obj.send(:attr, *block)
      when 'attr_reader'
        obj.send(:attr_reader, *block)
      when 'attr_writer'
        obj.send(:attr_writer, *block)
      when 'attr_accessor'
        obj.send(:attr_accessor, *block)
      when 'alias', 'alias_method'
        block.each { |k,v| obj.send(:alias_method, k, v) }
      else
        is_private = name.start_with?('_')
        name.sub!(/^_/, '') if is_private

        bang = %w[include extend initialize].include?(name.to_s) ? name : "#{name}!"

        block.respond_to?(:to_proc) ?
          obj.send(:define_method, bang, &block) :
          obj.send(:define_method, bang){ block }

        return if bang == name

        if Class === obj
          method = obj.instance_method(bang)
          obj.send(:define_method, name) do |*a, &b|
            return send(bang, *a, &b) if b || a.any?
            method.bind(self)
          end
        else
          method = obj.method(bang)
          obj.send(:define_method, name) do |*a, &b|
            return send(bang, *a, &b) if b || a.any?
            method
          end
        end

        if is_private
          obj.send :private, bang
          obj.send :private, name
        end
      end
    end

    def gen_const(name, object_type)
      context = respond_to?(:const_set) ? self : Object
      obj = context.const_defined?(name) ?
        context.const_get(name) :
        context.const_set(name, object_type)
      obj
    end
  end
end
