class BatchImportsController < ApplicationController

  load_and_authorize_resource
  
  def create
    @batch_import = BatchImport.new(params[:batch_import].merge(depositor: current_user.user_key))
    if @batch_import.valid?
      BatchImportJob.perform_later(manifest_file: @batch_import.manifest_file_full_path,
                                   files_directory: @batch_import.files_directory_full_path,
                                   depositor: @batch_import.depositor,
                                   collection_id: @batch_import.collection_id)
      render 'queued'
    else
      render 'new'
    end
  end

end
