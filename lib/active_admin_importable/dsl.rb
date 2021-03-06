module ActiveAdminImportable
  module DSL
    def active_admin_importable(&block)
      action_item :import, only: :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end

      collection_action :import_csv, :method => :post do
        result = CsvDb.convert_save(active_admin_config.resource_class, params[:dump][:file], &block)
        if result
          flash[:notice] = 'Error in line: ' + result[:line].to_s
          flash[:error] = result[:message]
        else
          flash[:notice] = "#{active_admin_config.resource_name.to_s} imported successfully!"
        end
        redirect_to :action => :index
      end
    end
  end
end
