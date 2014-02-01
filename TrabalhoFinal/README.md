com.isel.si1314.asi
===================
ISEL MEIC si1314 ASI Trabalho Final

===================
ToDo
	Relatorio
		Esquema Logico Global:
			Produto(Id[PK],IdFornecedor[FK],Codigo,Tipo,Designacao,Preco,QuantidadeStock,QuantidadeStockMin)
			Fornecedor(Id[PK],Numero,Nome,Morada)
			???? Tipo(Id[PK],Codigo,Nome) ????
		Esquema Fragmentacao
			Particao Vertical:
				ProdutoSede(Id[PK],IdFornecedor[FK],Codigo,Tipo,Designacao,Preco,QuantidadeStock,QuantidadeStockMin)
				ProdutoLojas(Id[PK],Codigo,Preco,QuantidadeStock)
			Particao Horizontal:
				ProdutoLojas1=SELECAO{tipo='CS'}(ProdutoLojas)
				ProdutoLojas2=SELECAO{tipo='HD'}(ProdutoLojas)
	
	Separar projectos em solucoes adequadas!!!!
				
   ASIVesteSedeDataLayer: Camada de acesso (Class Library) a dados a partir do EF_SPs_View, 
   ASIVesteSedeAppLayer.SedeServico.svc: adicionar codigo de negocio/acesso a dados(ASIVesteSedeDataLayer) às funções
   ASIVesteSede: Camada de apresentação, completar?, e chamar servico/operações de ASIVesteSedeAppLayer
   ?ASIVesteLojaAppLayer: Camada Aplicacional da Loja, referencia ASIVesteLojaDataLayer
      LojaServico.svc/ILojaServico.svc
         {efectuaVenda; obtemProdutos} - chamam ASIVesteLojaDataLayer
   ?ASIVesteLojaDataLayer: Camada de acesso a dados da Loja
   ?ASIVesteLoja: Camada de apresentação da Loja
   ?Base de dados Loja
   ?Replicacao base de dados Sede->Loja				
				
	QueueVendas.VendaServico.enviaVenda
		Console.Write("You entered: {0}", venda);//TODO: DELETE AFTER TESTES?
	ASIVesteSedeAppLayer.ISedeServico
        /// TODO: Comentarios
	ASIVesteSedeAppLayer.SedeServico
        //TODO: LOGICA DE NEGOCIO/ACESSO A DADOS
===================
