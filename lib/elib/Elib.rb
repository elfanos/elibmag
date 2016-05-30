module Elib
  #containers
    class ProductContainer
      attr_reader :productID
      attr_reader :formatGroupID
      def initialize(productID, formatGroupID)
        @productID = productID
        @formatGroupID = formatGroupID
      end
    end
    class EbookContainer
      attr_reader :productID
      attr_reader :formatGroupID
      attr_reader :author
      attr_reader :description
      attr_reader :distributor

      def initialize(productID, formatGroupID, author, description, distributor)
        @productID = productID
        @formatGroupID = formatGroupID
        @author = author
        @description = description
        @distributor = distributor
      end
    end

  class OrderContainer
    attr_reader :productID
    attr_reader :formatGroupID
    attr_reader :userID
    def initialize(productID, fromatGroupID, userID)
      @productID = productID
      @formatGroupID = formatGroupID
      @userID = userID
    end
  end
  class FormatContainer
  end
  class CategoryContainer
  end
  #Json serializers
  class JsonSerializers
  def initialize(json)
    @json = json
  end

  def find_all_values_using_key(key)
    result = []
    result << @json[key]
    unless @json.values.nil? && @json.values.empty?
      @json.values.each do |values|
        values = [values] unless values.is_a? Array
        values.each do |value|
          finder = Elib::JsonSerializers.new(value)
          result += finder.find_all_values_using_key(key) if value.is_a? Hash
        end
      end
    end
    return result
  end
  def remove_nil_and_blank(jsonhash)
    temp = []
    jsonhash.each do |value|
      if value.blank? == true && value.nil? == true
              puts "nil"
        else
        puts 'inne i loopen', value
        temp = value
        #  Book.create!(row.to_hash)
      end
    end
    return temp
  end

  end
  #Handlers
  class EbookHandler < JsonSerializers
    Ebooks_list = []

    def initialize
      @array_of_hashes = []
    end

    def insert_product_to_list(ebook)
      @ebook = ebook
      set_ebooks_list(@ebook.productID ,@ebook.formatGroupID,@ebook.author, @ebook.description, @ebook.distributor)
    end
    #Return array_of_hashes needs the hashes
    #to be valid when use post request to elib
    def get_ebooks_in_array_of_hashes
        get_ebooks_list.each { |record| @array_of_hashes << {'ProductID' => record[0].to_i, 'FormatGroupID' => record[1].to_i,'Author' => record[2].to_s,'Description' => record[3].to_s ,'Distributor' => record[4].to_s }}
        @array_of_hashes
    end
    def get_ebooks_list
        return Ebooks_list
    end
    def set_ebooks_list(productID, formatGroupID, author, description, distributor)
        Ebooks_list << [productID, formatGroupID, author, description, distributor]
    end
    def save_ebook_to_database(jsonValue)
        @jsonValue = jsonValue
        finder = Elib::JsonSerializers.new(@jsonValue)
        products = finder.find_all_values_using_key("Products")
        puts 'Products', products
        newProduct = self.remove_nil_and_blank(products)
        newProduct.each do |value|
          puts 'inne i loopen', value
          if Ebook.where(:productID => value['ProductID']).present?
            puts 'update'
          #  Book.create!(row.to_hash)
            #TODO
            #Fix update function
          else
            newBook = Ebook.new(:productID => value['ProductID'].to_i, :formatGroupId=>value['FormatGroupID'].to_i,:author=>value['Author'],:description=>value['Description'],:distributor=>value['Distributor'])
            newBook.save
          end
        end
      end
      def get_ebook_from_database
        @allEbooks = Ebook.all
      end
      private
        def ebook_params
          params.require(:ebook).permit(:productID, :formatGroupId, :author, :description, :distributor)
        end
    end

  class ProductHandler < JsonSerializers

    def initialize
      @array_of_hashes = []
      @productList = []
    end

    def insert_product_to_list(product)
      @product = product
      set_product_list(@product.productID, @product.formatGroupID)
    end
    #Return array_of_hashes needs the hashes
    #to be valid when use post request to elib
    def get_product_in_array_of_hashes
        get_product_list.each { |record| @array_of_hashes << {'ProductID' => record[0].to_i, 'FormatGroupID' => record[1].to_i} }
        @array_of_hashes
    end
    def get_product_list
        return @productList
    end
    def set_product_list(productID, formatGroupID)
        @productList << [productID, formatGroupID]
    end
    def serialize_product_for_order(productInArrayOfHash)
      @everyProductID = nil
      @everyFormatID = nil
      @productArray = []
      productInArrayOfHash.each do |value|
        if @everyProductID != nil && @everyFormatID !=nil
          @everyProductID << "#{value['ProductID']}"
          @everyFormatID << "#{value['FormatGroupID']}"
          product = Elib::ProductContainer.new(@everyProductID,@everyFormatID)
          @productArray << product

        else
          @everyProductID = "#{value['ProductID']}"
          @everyFormatID = "#{value['FormatGroupID']}"
          product = Elib::ProductContainer.new(@everyProductID,@everyFormatID)
          @productArray <<  product
        end
      end
      return @productArray
    end
  end

  class ViewBookHandler < JsonSerializers
      def initialize(userID)

        @userID = userID
      end
      def get_books
        #test orderID 15547534
        @jsonValue = Elib::ElibAPI.get_order_from_elibAPI(15565760)

        #puts 'Le value to fix', @jsonValue

      end
      def get_ebook_in_epub
         ebookFormat = self.get_different_formats(105)
        #puts 'ebookFormat' , ebookFormat
         ebookUrl = self.get_ebook_url(ebookFormat)

        puts 'theBook url' , ebookUrl

        return ebookUrl
      end
      def get_different_formats(formatID)
        finder = Elib::JsonHandler.new(@jsonValue)
        temp = finder.find_all_values_using_key("OrderFormats")
        orderFormats  = finder.remove_nil_and_blank(temp)
        puts 'innan ifsatster', formatID
        if formatID == 101
          return orderFormats.select {|value| value["FormatID"] == 101 }
        elsif formatID == 102
          return orderFormats.select {|value| value["FormatID"] == 102 }
        elsif formatID == 103
          return orderFormats.select {|value| value["FormatID"] == 103 }
        elsif formatID == 104
          return orderFormats.select {|value| value["FormatID"] == 104 }
        elsif formatID == 105
          return orderFormats.select {|value| value["FormatID"] == 105 }
        elsif formatID == 106
          return orderFormats.select {|value| value["FormatID"] == 106 }
        elsif formatID == 107
          return orderFormats.select {|value| value["FormatID"] == 107 }
        elsif formatID == 110
          return orderFormats.select {|value| value["FormatID"] == 110 }
        else
          #todo
          #puts 'i elsen'
        end
        #puts 'no if'
        return "hej"
        # orderFormats each do |value|
        #   if value['FormatID'].
        # end
      end
      def get_ebook_url(ebookJson)
        url = nil
        puts 'ebook url', ebookJson
        ebookJson.each do |value|
          if value['Contents']
              #puts 'haj', value['Contents']
              contents = value['Contents']
              contents.each do |contentsValue|
                if contentsValue['Url']
                  #puts 'haj' ,contentsValue['Url']
                  url = contentsValue['Url']
                else
                  #puts 'nejn2'
                end
              end
          else
          end
        end

        return url
      end

  end
  class OrderHandler

    def initialize(productID, formatGroupID, userID)
      @productID = productID
      @formatGroupID = 100
      @userID = userID
    end

    def send_order_to_elib
      ##Intialize product object
      productContainer = Elib::ProductContainer.new(@productID,@formatGroupID)
      ##Intialize order
      orderContainer = Elib::OrderContainer.new(@productID,@formatGroupID, @userID)
      ##Product handler for elibs-jsonformat
      productHandler = Elib::ProductHandler.new
      ##Intialize communication with API
      productHandler.insert_product_to_list(productContainer)

      Elib::ElibAPI.post_order_to_elib_api(13, productHandler.get_product_in_array_of_hashes)

    end
    def save_order
      if Order.where(:productsID => @productID, :formatID =>  @formatGroupID, :user_id => @userID).present?
        puts 'update'
      #  Book.create!(row.to_hash)
      else
      newOrder = Order.new(:productsID => @productID, :formatID =>  @formatGroupID, :user_id => @userID)
      newOrder.save
      end
    end


  end
  class ElibAPI
    SERVICE_SECRET = ENV["elib_service_secret"]
    SERVICE_ID = ENV["elib_service_id"].to_i
    SERVICE_SECRET_CHECKSUM = Digest::MD5.hexdigest(ENV["elib_service_secret"])

    def self.get_products_from_elib(startDate,endDate)
      puts "SERVICE" ,SERVICE_SECRET
      response =RestClient::Request.execute(method: :get, url: 'https://webservices.elib.se/shop/v3.0/products',
                            headers: {Accept: "application/json", params: {ServiceID: SERVICE_ID, ServiceKey: SERVICE_SECRET_CHECKSUM, From: startDate, To: endDate}})

      puts 'check it' , response
      value = JSON.parse(response)
      puts 'value' , value
      #test
      bookHandler = Elib::EbookHandler.new
      #Elib::ElibAPI.run_test_on_get_products(value)
      puts "check the test array", Elib::ElibAPI.run_test_on_get_products(value)
      bookHandler.save_ebook_to_database(Elib::ElibAPI.run_test_on_get_products(value))
      bookHandler.get_ebook_from_database


    end
    def self.post_order_to_elib_api(order_id, productInArrayOfHash)
      handler = Elib::ProductHandler.new
      checksum_of_every_parameters = Elib::ElibAPI.post_checksum(SERVICE_SECRET,SERVICE_ID,handler.serialize_product_for_order(productInArrayOfHash),order_id)
      puts 'check sum para', checksum_of_every_parameters
      responseorder =RestClient::Request.execute(method: :post, url: 'https://webservices.elib.se/shop/v3.0/ordergroups',:payload => {:ServiceID => SERVICE_ID, :ServiceKey => SERVICE_SECRET_CHECKSUM, :OrderGroupID => order_id, :Products => productInArrayOfHash, :Checksum => checksum_of_every_parameters}.to_json,
                            headers: {:content_type => 'application/json', :accept => 'application/json'})
      #test 2
      #testrespone2 = RestClient.post "https://webservices.elib.se/shop/v3.0/ordergroups",{:ServiceID => SERVICE_ID, :ServiceKey => SERVICE_SECRET_CHECKSUM, :OrderGroupID => order_id, :Products => array_of_hashes, :Checksum => checksum_of_every_parameters}.to_json, :content_type => 'application/json', :accept => 'application/json'
      puts 'request',responseorder.code
      puts 'json' , responseorder.body
    end
    def self.get_order_from_elibAPI(orderID)
      puts 'order id value', orderID
      response =RestClient::Request.execute(method: :get, url: 'https://webservices.elib.se/shop/v3.0/ordergroups',
                            headers: {Accept: "application/json", params: {ServiceID: @@SERVICE_ID, ServiceKey: @@SERVICE_SECRET_CHECKSUM, OrderGroupID: orderID, IsElibID: true}})
      value = JSON.parse(response)
      puts 'ordeID', value
      return value
    end
    def self.post_checksum(serviceSecret,serviceID, productInArrayOfHash,order_id)

      sumOfPara= nil
      #sum_of_every_parameters = "2399123451005450100EWKk16eqvDd9lmNI2oHYcOfhprAzBnxLG73VPTXutwQ4R8FUiS"
      sumOfPara = serviceID.to_s+order_id.to_s+123.to_s+124.to_s+serviceSecret,serviceID
      puts 'checkt the para', sumOfPara
      checkSumOfEveryPara = Digest::MD5.hexdigest(sumOfPara.to_s)

    end
    def self.run_test_on_get_products(jsonValue)
      firstBook = Elib::EbookContainer.new(1001714,100,	"Martin Widmark"	,"The Mummy Mystery", "Bonnier")
      secondBook = Elib::EbookContainer.new(1001826, 100, "Ingrid Sandhagen","Lilla Q","Bonnier")
      bookHandler = Elib::EbookHandler.new
      bookHandler.insert_product_to_list(firstBook)
      bookHandler.insert_product_to_list(secondBook)

      puts 'check if right', jsonValue["Result"]["NumberOfProducts"]
      jsonValue["Result"]["NumberOfProducts"] = 2
      puts 'inserted values', jsonValue["Result"]["NumberOfProducts"]

      puts 'products ', jsonValue["Result"]["Products"]
      jsonValue["Result"]["Products"] = bookHandler.get_ebooks_in_array_of_hashes
      puts 'check product after insert', jsonValue["Result"]["Products"]
      return jsonValue
    end
  end
end
