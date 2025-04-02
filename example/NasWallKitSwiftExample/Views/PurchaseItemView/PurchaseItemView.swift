//
// 아이템 구입 메인 화면
//

import NasWallKit
import SwiftUI

/// 아이템 구입 화면 메인 `View`
struct PurchaseItemView: View {
    // MARK: - Environment
    
    /// NasWallKit - 회원 보유 적립금 조회
    @EnvironmentObject private var nwkUserPoint: NasWallKit_UserPoint
    
    // MARK: - Variable
    
    /// NasWallKit - 아이템 목록 조회
    @StateObject private var nwkItemList = NasWallKit_ItemList()
    /// NasWallKit - 아이템 구입
    @StateObject private var nwkPurchaseItem = NasWallKit_PurchaseItem()
    /// 선택된 아이템 정보
    @State private var selectedItem: NasWallItemInfo?
    /// 구입 오류 얼럿 표시 여부
    @State private var showPurchaseErrorAlert: Bool = false
    
    // MARK: - Function
    
    /// 아이템 목록 조회
    private func loadItemList() {
        nwkItemList.loadData(.default) { error in
            if error == nil {
                // 아이템 목록 조회 성공
                
                selectedItem = nil
                
                if let list = nwkItemList.data, list.isEmpty == false {
                    // 아이템이 있으면, 첫 번째 아이템을 선택 아이템으로 지정
                    selectedItem = list.first
                } else {
                    selectedItem = nil
                }
            }
        }
    }
    
    /// 회원 보유 적립금 조회
    private func loadUserPoint() {
        nwkUserPoint.loadData()
    }
    
    /// 아이템 구입하기
    private func purchaseItem() {
        guard let itemId = selectedItem?.id else {
            // 선택된 아이템 없음
            return
        }
        nwkPurchaseItem.loadData(itemId, qty: 1) { error in
            if error != nil {
                // 구입 실패 시 얼럿 표시
                showPurchaseErrorAlert = true
            }
        }
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            // 아이템 목록 조회 상태 별 UI
            switch nwkItemList.status {
                // 아이템 목록 조회 중
            case .idle, .loading:
                ProgressView()
                
                // 아이템 목록 조회 실패
            case .fail:
                ErrorRetry(nwkItemList.error, action: loadItemList)
                
                // 아이템 목록 조회 성공
            case .success:
                if let list = nwkItemList.data { // 아이템 목록 데이터 있는지 검사
                    List {
                        // 회원 보유 적립금
                        Section {
                            HStack {
                                Text("보유 적립금")
                                
                                Spacer()
                                
                                // 회원 보유 적립금 조회 상태 별 UI
                                switch nwkUserPoint.status {
                                case .idle, .loading: // 회원 보유 적립금 조회 중
                                    ProgressView()
                                    
                                case .fail: // 회원 보유 적립금 조회 실패
                                    Button("재시도", action: loadUserPoint)
                                    
                                case .success: // 회원 보유 적립금 조회 성공
                                    if let data = nwkUserPoint.data {
                                        Text(data.stringValue)
                                            .font(.subheadline)
                                            .foregroundColor(.primary.opacity(0.7))
                                    }
                                }
                            }
                        }
                        
                        // 아이템 목록
                        Section {
                            if list.isEmpty {
                                // 아이템이 없는 경우, 안내 메시지 표시
                                NoDataView("구입 가능한 아이템이 없습니다.\n\nNAS 개발자 홈페이지의 \"매체관리\" 메뉴에서 아이템을 등록해주세요.")
                                    .padding(.vertical)
                                
                            } else {
                                // 아이템이 있는 경우, 아이템 목록 표시
                                ForEach(list) { item in
                                    Button {
                                        selectedItem = item
                                    } label: {
                                        HStack {
                                            // Radio 아이콘
                                            Image(systemName: item == selectedItem ? "largecircle.fill.circle" : "circle")
                                            
                                            // 아이템 이름
                                            Text(item.name)
                                            
                                            Spacer()
                                            
                                            // 가격
                                            Text("\(item.price.formatted())\(item.unit)")
                                        }
                                    }
                                }
                                // 구입 처리 중이면, 아이템 목록 disable 처리
                                .disabled(nwkPurchaseItem.status == .loading)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 아이템이 있는 경우, 구입하기 버튼 표시
                    if list.isEmpty == false {
                        MyButton("구입하기", loading: nwkPurchaseItem.status == .loading, action: purchaseItem)
                            .padding()
                    }
                }
            }
        }
        .navigationTitle("아이템 구입")
        .navigationBarTitleDisplayMode(.inline)
        // 구매 처리 중이면, Back 버튼 disable 처리
        .navigationBarBackButtonHidden(nwkPurchaseItem.status == .loading)
        // 구입 실패 얼럿
        .alert("구입 실패", isPresented: $showPurchaseErrorAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            if let error = nwkPurchaseItem.error {
                Text("(\(error.code)) \(error.localizedDescription)")
            } else {
                Text("구입할 수 없습니다.")
            }
        }
        .onAppear {
            // 아이템 목록 조회
            loadItemList()
            
            // 회원 보유 적립금 조회 실패 상태이면, 조회 시작
            if nwkUserPoint.status == .idle || nwkUserPoint.status == .fail {
                loadUserPoint()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    // 필요 시 Preview 전용 데이터 로드 지연 시간(초) 지정을 설정합니다.
    NasWall.debugPreviewDataDelaySeconds(0)
    
    /// NasWallKit - 회원 보유 적립금 조회
    let nwkUserPoint = NasWallKit_UserPoint()
    
    return PreviewNavigationView("PurchaseItemView") {
        PreviewNasWallInitView {
            PurchaseItemView()
                .environmentObject(nwkUserPoint)
                .onAppear {
                    nwkUserPoint.loadData()
                }
        }
    }
}
