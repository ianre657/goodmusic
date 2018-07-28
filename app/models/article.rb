class Article < ApplicationRecord
    has_one :article_detail
    belongs_to :article_type
    has_one_attached :image

    def update_with_content( param , opt={ brief:nil, length:30} )
        # 擷取限制長度的字串當作簡短介紹
        # 當 brief不為nil的時候採用客製化的簡介來當作文章介紹
        # length指定剪下預設的文章簡介長度
        content = self.brief 
        if opt[:brief].nil?
            raise Exception.new('length cannot be less or equal to 0') if length <=0;
            self.brief = self.brief[0..opt[:length]]
        else
            self.brief = opt[:brief]
        end

        if self.update( param.except(:content) )
            if !self.article_detail.present?
                self.create_article_detail({content: content})
            else
                self.article_detail[:content]= content
            end
            return true
        else
            return false
        end

    end

end
