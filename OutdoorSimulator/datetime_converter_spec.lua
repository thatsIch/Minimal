describe('Busted unit testing framework', function()
  describe('should be awesome', function()
    it('should be easy to use', function()
      assert.truthy('Yup.')
    end)

    it('should have lots of features', function()
      -- deep check comparisons!
      assert.same({ table = 'great'}, { table = 'great' })

      -- or check by reference!
      assert.is_not.equals({ table = 'great'}, { table = 'great'})

      assert.falsy(nil)
      assert.error(function() error('Wat') end)
    end)

    it('should provide some shortcuts to common functions', function()
      -- given
      -- TODO there is a problem because the setter lua is a UTF 16 encoded file and busted can not test this
      dofile("OutdoorSimulator/setter.lua")
      local time = 1598262282
      local expected = 24407724.840604166666666666666667
      
      -- when
      local actual = convertUnixToJulian(time)

      assert.same(actual, expected)
    end)
  end)
end)